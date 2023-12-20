import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { MessagingDevicesResponse } from "firebase-admin/lib/messaging/messaging-api";
import moment from "moment";
import { LINKSTUDENTREQUEST_ERROR_NOT_FOUND } from "src/common/constant/link-student-request.constant";
import {
  NOTIF_TITLE,
  NOTIF_TYPE,
} from "src/common/constant/notifications.constant";
import { PARENTS_ERROR_NOT_FOUND } from "src/common/constant/parents.constant";
import { SCHOOLS_ERROR_NOT_FOUND } from "src/common/constant/schools.constant";
import { STUDENTS_ERROR_NOT_FOUND } from "src/common/constant/students.constant";
import { CONST_QUERYCURRENT_TIMESTAMP } from "src/common/constant/timestamp.constant";
import { TAPLOGS_ERROR_NOT_FOUND } from "src/common/constant/top-logs.constant";
import { USER_ERROR_USER_NOT_FOUND } from "src/common/constant/user-error.constant";
import {
  columnDefToTypeORMCondition,
  generateIndentityCode,
} from "src/common/utils/utils";
import { CreateTapLogDto } from "src/core/dto/tap-logs/tap-logs.create.dto";
import { FirebaseProvider } from "src/core/provider/firebase/firebase-provider";
import { Notifications } from "src/db/entities/Notifications";
import { ParentStudent } from "src/db/entities/ParentStudent";
import { Parents } from "src/db/entities/Parents";
import { Schools } from "src/db/entities/Schools";
import { Students } from "src/db/entities/Students";
import { TapLogs } from "src/db/entities/TapLogs";
import { UserFirebaseToken } from "src/db/entities/UserFirebaseToken";
import { Users } from "src/db/entities/Users";
import { Repository, EntityManager } from "typeorm";
import { PusherService } from "./pusher.service";
import { Machines } from "src/db/entities/Machines";
import { MACHINES_ERROR_NOT_FOUND } from "src/common/constant/machines.constant";

@Injectable()
export class TapLogsService {
  constructor(
    @InjectRepository(TapLogs)
    private readonly tapLogsRepo: Repository<TapLogs>,
    private pusherService: PusherService,
    private firebaseProvoder: FirebaseProvider
  ) {}
  async getPagination({ pageSize, pageIndex, order, columnDef }) {
    const skip =
      Number(pageIndex) > 0 ? Number(pageIndex) * Number(pageSize) : 0;
    const take = Number(pageSize);

    const condition = columnDefToTypeORMCondition(columnDef);
    const [results, total] = await Promise.all([
      this.tapLogsRepo.find({
        where: condition,
        relations: {
          student: {
            parentStudents: true,
          },
          machine: true,
        },
        skip,
        take,
        order,
      }),
      this.tapLogsRepo.count({
        where: condition,
      }),
    ]);
    return {
      results,
      total,
    };
  }

  async getByCode(tapLogId) {
    const result = await this.tapLogsRepo.findOne({
      where: {
        tapLogId,
      },
      relations: {
        student: {
          parentStudents: true,
        },
        machine: true,
      },
    });
    if (!result) {
      throw Error(TAPLOGS_ERROR_NOT_FOUND);
    }
    return result;
  }

  async create(dto: CreateTapLogDto) {
    return await this.tapLogsRepo.manager.transaction(async (entityManager) => {
      let tapLogs = new TapLogs();
      const timestamp = await entityManager
        .query(CONST_QUERYCURRENT_TIMESTAMP)
        .then((res) => {
          return res[0]["timestamp"];
        });
      tapLogs.dateTime = dto.dateTime;
      tapLogs.status = dto.status;
      const student = await entityManager.findOne(Students, {
        where: {
          cardNumber: dto.cardNumber,
          active: true,
        },
      });
      if (!student) {
        throw Error(STUDENTS_ERROR_NOT_FOUND);
      }
      tapLogs.student = student;
      const machine = await entityManager.findOne(Machines, {
        where: {
          description: dto.sender,
          active: true,
        },
      });
      if (!student) {
        throw Error(MACHINES_ERROR_NOT_FOUND);
      }
      tapLogs.machine = machine;

      tapLogs = await entityManager.save(TapLogs, tapLogs);

      const parentStudents = await entityManager.find(ParentStudent, {
        select: {
          parent: {
            user: {
              userFirebaseTokens: true,
            },
          },
        },
        where: {
          student: {
            studentId: student.studentId,
          },
        },
        relations: {
          parent: {
            user: {
              userFirebaseTokens: true,
            },
          },
        },
      });

      const userFireBase: UserFirebaseToken[] = [];
      for (const parentStudent of parentStudents) {
        if (
          parentStudent.parent &&
          parentStudent.parent.user &&
          parentStudent.parent.user.userFirebaseTokens
        ) {
          for (const userFirebaseToken of parentStudent.parent.user
            .userFirebaseTokens) {
            if (
              !userFireBase.some(
                (x) => x.firebaseToken === userFirebaseToken.firebaseToken
              )
            ) {
              userFireBase.push(userFirebaseToken);
            }
          }
        }
      }

      if (userFireBase.length > 0) {
        const title = student?.fullName;
        let desc;
        if ((dto.status = "LOG IN")) {
          desc = `Your child, ${
            student?.fullName
          } has arrived in the school at ${moment(dto.dateTime).format(
            "hh:mm A"
          )}`;
        } else {
          desc = `Your child, ${
            student?.fullName
          } has left the school premises at ${moment(dto.dateTime).format(
            "hh:mm A"
          )}`;
        }

        userFireBase.forEach(async (x) => {
          if (x.firebaseToken && x.firebaseToken !== "") {
            const res = await this.firebaseSendToDevice(
              x.firebaseToken,
              title,
              desc
            );
            console.log(res);
          }
        });
        await this.logNotification(
          parentStudents.map((x) => x.parent.user),
          tapLogs.tapLogId,
          entityManager,
          title,
          desc
        );
      }
      return tapLogs;
    });
  }

  async logNotification(
    users: Users[],
    referenceId,
    entityManager: EntityManager,
    title: string,
    description: string
  ) {
    const notifcations = [];
    users.forEach((x) => {
      notifcations.push({
        title,
        description,
        type: NOTIF_TYPE.LINK_REQUEST.toString(),
        referenceId,
        isRead: false,
        forUser: x,
      });
    });
    await entityManager.save(Notifications, notifcations);
  }

  async firebaseSendToDevice(token, title, description) {
    return await this.firebaseProvoder.app
      .messaging()
      .sendToDevice(
        token,
        {
          notification: {
            title: title,
            body: description,
            sound: "notif_alert",
          },
        },
        {
          priority: "high",
          timeToLive: 60 * 24,
          android: { sound: "notif_alert" },
        }
      )
      .then((response: MessagingDevicesResponse) => {
        console.log("Successfully sent message:", response);
      })
      .catch((error) => {
        throw new HttpException(
          `Error sending notif! ${error.message}`,
          HttpStatus.BAD_REQUEST
        );
      });
  }
}
