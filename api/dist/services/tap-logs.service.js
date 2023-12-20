"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TapLogsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const moment_1 = __importDefault(require("moment"));
const notifications_constant_1 = require("../common/constant/notifications.constant");
const students_constant_1 = require("../common/constant/students.constant");
const timestamp_constant_1 = require("../common/constant/timestamp.constant");
const top_logs_constant_1 = require("../common/constant/top-logs.constant");
const utils_1 = require("../common/utils/utils");
const firebase_provider_1 = require("../core/provider/firebase/firebase-provider");
const Notifications_1 = require("../db/entities/Notifications");
const ParentStudent_1 = require("../db/entities/ParentStudent");
const Students_1 = require("../db/entities/Students");
const TapLogs_1 = require("../db/entities/TapLogs");
const typeorm_2 = require("typeorm");
const pusher_service_1 = require("./pusher.service");
const Machines_1 = require("../db/entities/Machines");
const machines_constant_1 = require("../common/constant/machines.constant");
let TapLogsService = class TapLogsService {
    constructor(tapLogsRepo, pusherService, firebaseProvoder) {
        this.tapLogsRepo = tapLogsRepo;
        this.pusherService = pusherService;
        this.firebaseProvoder = firebaseProvoder;
    }
    async getPagination({ pageSize, pageIndex, order, columnDef }) {
        const skip = Number(pageIndex) > 0 ? Number(pageIndex) * Number(pageSize) : 0;
        const take = Number(pageSize);
        const condition = (0, utils_1.columnDefToTypeORMCondition)(columnDef);
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
            throw Error(top_logs_constant_1.TAPLOGS_ERROR_NOT_FOUND);
        }
        return result;
    }
    async create(dto) {
        return await this.tapLogsRepo.manager.transaction(async (entityManager) => {
            let tapLogs = new TapLogs_1.TapLogs();
            const timestamp = await entityManager
                .query(timestamp_constant_1.CONST_QUERYCURRENT_TIMESTAMP)
                .then((res) => {
                return res[0]["timestamp"];
            });
            tapLogs.dateTime = dto.dateTime;
            tapLogs.status = dto.status;
            const student = await entityManager.findOne(Students_1.Students, {
                where: {
                    cardNumber: dto.cardNumber,
                    active: true,
                },
            });
            if (!student) {
                throw Error(students_constant_1.STUDENTS_ERROR_NOT_FOUND);
            }
            tapLogs.student = student;
            const machine = await entityManager.findOne(Machines_1.Machines, {
                where: {
                    description: dto.sender,
                    active: true,
                },
            });
            if (!machine) {
                throw Error(machines_constant_1.MACHINES_ERROR_NOT_FOUND);
            }
            tapLogs.machine = machine;
            tapLogs = await entityManager.save(TapLogs_1.TapLogs, tapLogs);
            const parentStudents = await entityManager.find(ParentStudent_1.ParentStudent, {
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
            const userFireBase = [];
            for (const parentStudent of parentStudents) {
                if (parentStudent.parent &&
                    parentStudent.parent.user &&
                    parentStudent.parent.user.userFirebaseTokens) {
                    for (const userFirebaseToken of parentStudent.parent.user
                        .userFirebaseTokens) {
                        if (!userFireBase.some((x) => x.firebaseToken === userFirebaseToken.firebaseToken)) {
                            userFireBase.push(userFirebaseToken);
                        }
                    }
                }
            }
            if (userFireBase.length > 0) {
                const title = student === null || student === void 0 ? void 0 : student.fullName;
                let desc;
                if ((dto.status = "LOG IN")) {
                    desc = `Your child, ${student === null || student === void 0 ? void 0 : student.fullName} has arrived in the school at ${(0, moment_1.default)(dto.dateTime).format("hh:mm A")}`;
                }
                else {
                    desc = `Your child, ${student === null || student === void 0 ? void 0 : student.fullName} has left the school premises at ${(0, moment_1.default)(dto.dateTime).format("hh:mm A")}`;
                }
                userFireBase.forEach(async (x) => {
                    if (x.firebaseToken && x.firebaseToken !== "") {
                        const res = await this.firebaseSendToDevice(x.firebaseToken, title, desc);
                        console.log(res);
                    }
                });
                await this.logNotification(parentStudents.map((x) => x.parent.user), tapLogs.tapLogId, entityManager, title, desc);
            }
            return tapLogs;
        });
    }
    async logNotification(users, referenceId, entityManager, title, description) {
        const notifcations = [];
        users.forEach((x) => {
            notifcations.push({
                title,
                description,
                type: notifications_constant_1.NOTIF_TYPE.LINK_REQUEST.toString(),
                referenceId,
                isRead: false,
                forUser: x,
            });
        });
        await entityManager.save(Notifications_1.Notifications, notifcations);
    }
    async firebaseSendToDevice(token, title, description) {
        return await this.firebaseProvoder.app
            .messaging()
            .sendToDevice(token, {
            notification: {
                title: title,
                body: description,
                sound: "notif_alert",
            },
        }, {
            priority: "high",
            timeToLive: 60 * 24,
            android: { sound: "notif_alert" },
        })
            .then((response) => {
            console.log("Successfully sent message:", response);
        })
            .catch((error) => {
            throw new common_1.HttpException(`Error sending notif! ${error.message}`, common_1.HttpStatus.BAD_REQUEST);
        });
    }
};
TapLogsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(TapLogs_1.TapLogs)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        pusher_service_1.PusherService,
        firebase_provider_1.FirebaseProvider])
], TapLogsService);
exports.TapLogsService = TapLogsService;
//# sourceMappingURL=tap-logs.service.js.map