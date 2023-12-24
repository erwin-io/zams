import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { DEPARTMENTS_ERROR_NOT_FOUND } from "src/common/constant/departments.constant";
import { EMPLOYEEROLES_ERROR_NOT_FOUND } from "src/common/constant/employees-roles.constant";
import { PARENTS_ERROR_NOT_FOUND } from "src/common/constant/parents.constant";
import { SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND } from "src/common/constant/school-year-levels.constant";
import { SCHOOLS_ERROR_NOT_FOUND } from "src/common/constant/schools.constant";
import { CONST_QUERYCURRENT_TIMESTAMP } from "src/common/constant/timestamp.constant";
import { USER_ERROR_USER_NOT_FOUND } from "src/common/constant/user-error.constant";
import { USER_TYPE } from "src/common/constant/user-type.constant";
import {
  columnDefToTypeORMCondition,
  hash,
  generateIndentityCode,
} from "src/common/utils/utils";
import { UpdateUserResetPasswordDto } from "src/core/dto/auth/reset-password.dto";
import { UpdateParentUserProfileDto } from "src/core/dto/parents/parents.update.dto";
import { Departments } from "src/db/entities/Departments";
import { Parents } from "src/db/entities/Parents";
import { Schools } from "src/db/entities/Schools";
import { Students } from "src/db/entities/Students";
import { Users } from "src/db/entities/Users";
import { Repository } from "typeorm";

@Injectable()
export class ParentsService {
  constructor(
    @InjectRepository(Parents)
    private readonly parentRepo: Repository<Parents>
  ) {}

  async getPagination({ pageSize, pageIndex, order, columnDef }) {
    const skip =
      Number(pageIndex) > 0 ? Number(pageIndex) * Number(pageSize) : 0;
    const take = Number(pageSize);
    const condition = columnDefToTypeORMCondition(columnDef);
    const [results, total] = await Promise.all([
      this.parentRepo.find({
        where: {
          ...condition,
          active: true,
        },
        relations: {
          parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
        skip,
        take,
        order,
      }),
      this.parentRepo.count({
        where: {
          ...condition,
          active: true,
        },
      }),
    ]);
    return {
      results: results.map((x) => {
        delete x.user.password;
        delete x.registeredByUser.password;
        if (x?.updatedByUser?.password) {
          delete x.updatedByUser.password;
        }
        return x;
      }),
      total,
    };
  }

  async getByCode(parentCode) {
    const res = await this.parentRepo.findOne({
      where: {
        parentCode,
        active: true,
      },
      relations: {
        parentStudents: {
          student: {
            school: true,
            studentCourse: {
              course: true,
            },
            schoolYearLevel: true,
          },
        },
        registeredByUser: true,
        updatedByUser: true,
        user: true,
      },
    });

    if (!res) {
      throw Error(USER_ERROR_USER_NOT_FOUND);
    }
    delete res.user.password;
    delete res.registeredByUser.password;
    if (res?.updatedByUser?.password) {
      delete res.updatedByUser.password;
    }
    return res;
  }

  async getParentStudents(parentCode) {
    const res = await this.parentRepo.manager.query<Students[]>(`
    SELECT
s."StudentId", 
s."StudentCode", 
s."DepartmentId", 
s."FirstName", 
s."middleInitial", 
s."LastName", 
s."LRN", 
s."CardNumber", 
s."BirthDate", 
s."MobileNumber", 
s."Email", 
s."Address", 
s."Gender" 
from dbo."Students" s
left join dbo."ParentStudent" ps ON s."StudentId" = ps."StudentId"
left join dbo."Parents" p ON ps."ParentId" = p."ParentId"
WHERE p."ParentCode" = '${parentCode}'
    `);
    return res;
  }
  async updateProfile(parentCode, dto: UpdateParentUserProfileDto) {
    return await this.parentRepo.manager.transaction(async (entityManager) => {
      let parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
          active: true,
        },
        relations: {
          // parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
      });

      if (!parent) {
        throw Error(PARENTS_ERROR_NOT_FOUND);
      }

      parent.firstName = dto.firstName;
      parent.middleInitial = dto.middleInitial;
      parent.lastName = dto.lastName;
      parent.fullName = `${dto.firstName} ${dto.lastName}`;
      parent.mobileNumber = dto.mobileNumber;
      const timestamp = await entityManager
        .query(CONST_QUERYCURRENT_TIMESTAMP)
        .then((res) => {
          return res[0]["timestamp"];
        });
      parent.updatedDate = timestamp;
      parent.updatedByUser = parent.user;
      parent = await entityManager.save(Parents, parent);

      parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
          active: true,
        },
        relations: {
          parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
      });
      delete parent.user.password;
      delete parent.registeredByUser.password;
      if (parent?.updatedByUser?.password) {
        delete parent.updatedByUser.password;
      }
      return parent;
    });
  }

  async resetPassword(parentCode, dto: UpdateUserResetPasswordDto) {
    return await this.parentRepo.manager.transaction(async (entityManager) => {
      let parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
          active: true,
        },
        relations: {
          user: true,
        },
      });

      if (!parent) {
        throw Error(PARENTS_ERROR_NOT_FOUND);
      }

      const user = parent.user;
      user.password = await hash(dto.password);
      await entityManager.save(Users, user);
      parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
          active: true,
        },
        relations: {
          parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
      });
      delete parent.user.password;
      delete parent.registeredByUser.password;
      if (parent?.updatedByUser?.password) {
        delete parent.updatedByUser.password;
      }
      return parent;
    });
  }

  async delete(parentCode) {
    return await this.parentRepo.manager.transaction(async (entityManager) => {
      let parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
          active: true,
        },
        relations: {
          parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
      });

      if (!parent) {
        throw Error(PARENTS_ERROR_NOT_FOUND);
      }

      parent.active = false;
      await entityManager.save(Parents, parent);
      const user = parent.user;
      user.active = false;
      await entityManager.save(Users, user);
      parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
        },
        relations: {
          parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
      });
      delete parent.user.password;
      delete parent.registeredByUser.password;
      if (parent?.updatedByUser?.password) {
        delete parent.updatedByUser.password;
      }
      return parent;
    });
  }

  async approveAccessRequest(parentCode) {
    return await this.parentRepo.manager.transaction(async (entityManager) => {
      let parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
          active: true,
        },
        relations: {
          parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
      });

      if (!parent) {
        throw Error(PARENTS_ERROR_NOT_FOUND);
      }

      await entityManager.save(Parents, parent);
      parent = await entityManager.findOne(Parents, {
        where: {
          parentCode,
        },
        relations: {
          parentStudents: true,
          registeredByUser: true,
          updatedByUser: true,
          user: true,
        },
      });
      delete parent.user.password;
      delete parent.registeredByUser.password;
      if (parent?.updatedByUser?.password) {
        delete parent.updatedByUser.password;
      }
      return parent;
    });
  }
}
