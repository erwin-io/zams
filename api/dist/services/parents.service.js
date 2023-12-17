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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ParentsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const parents_constant_1 = require("../common/constant/parents.constant");
const timestamp_constant_1 = require("../common/constant/timestamp.constant");
const user_error_constant_1 = require("../common/constant/user-error.constant");
const utils_1 = require("../common/utils/utils");
const Parents_1 = require("../db/entities/Parents");
const Users_1 = require("../db/entities/Users");
const typeorm_2 = require("typeorm");
let ParentsService = class ParentsService {
    constructor(parentRepo) {
        this.parentRepo = parentRepo;
    }
    async getPagination({ pageSize, pageIndex, order, columnDef }) {
        const skip = Number(pageIndex) > 0 ? Number(pageIndex) * Number(pageSize) : 0;
        const take = Number(pageSize);
        const condition = (0, utils_1.columnDefToTypeORMCondition)(columnDef);
        const [results, total] = await Promise.all([
            this.parentRepo.find({
                where: Object.assign(Object.assign({}, condition), { active: true }),
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
                where: Object.assign(Object.assign({}, condition), { active: true }),
            }),
        ]);
        return {
            results: results.map((x) => {
                var _a;
                delete x.user.password;
                delete x.registeredByUser.password;
                if ((_a = x === null || x === void 0 ? void 0 : x.updatedByUser) === null || _a === void 0 ? void 0 : _a.password) {
                    delete x.updatedByUser.password;
                }
                return x;
            }),
            total,
        };
    }
    async getByCode(parentCode) {
        var _a;
        const res = await this.parentRepo.findOne({
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
        if (!res) {
            throw Error(user_error_constant_1.USER_ERROR_USER_NOT_FOUND);
        }
        delete res.user.password;
        delete res.registeredByUser.password;
        if ((_a = res === null || res === void 0 ? void 0 : res.updatedByUser) === null || _a === void 0 ? void 0 : _a.password) {
            delete res.updatedByUser.password;
        }
        return res;
    }
    async updateProfile(parentCode, dto) {
        return await this.parentRepo.manager.transaction(async (entityManager) => {
            var _a;
            let parent = await entityManager.findOne(Parents_1.Parents, {
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
                throw Error(parents_constant_1.PARENTS_ERROR_NOT_FOUND);
            }
            parent.firstName = dto.firstName;
            parent.middleName = dto.middleName;
            parent.lastName = dto.lastName;
            parent.fullName = `${dto.firstName} ${dto.lastName}`;
            parent.mobileNumber = dto.mobileNumber;
            const timestamp = await entityManager
                .query(timestamp_constant_1.CONST_QUERYCURRENT_TIMESTAMP)
                .then((res) => {
                return res[0]["timestamp"];
            });
            parent.updatedDate = timestamp;
            parent.updatedByUser = parent.user;
            parent = await entityManager.save(Parents_1.Parents, parent);
            parent = await entityManager.findOne(Parents_1.Parents, {
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
            if ((_a = parent === null || parent === void 0 ? void 0 : parent.updatedByUser) === null || _a === void 0 ? void 0 : _a.password) {
                delete parent.updatedByUser.password;
            }
            return parent;
        });
    }
    async resetPassword(parentCode, dto) {
        return await this.parentRepo.manager.transaction(async (entityManager) => {
            var _a;
            let parent = await entityManager.findOne(Parents_1.Parents, {
                where: {
                    parentCode,
                    active: true,
                },
                relations: {
                    user: true,
                },
            });
            if (!parent) {
                throw Error(parents_constant_1.PARENTS_ERROR_NOT_FOUND);
            }
            const user = parent.user;
            user.password = await (0, utils_1.hash)(dto.password);
            await entityManager.save(Users_1.Users, user);
            parent = await entityManager.findOne(Parents_1.Parents, {
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
            if ((_a = parent === null || parent === void 0 ? void 0 : parent.updatedByUser) === null || _a === void 0 ? void 0 : _a.password) {
                delete parent.updatedByUser.password;
            }
            return parent;
        });
    }
    async delete(parentCode) {
        return await this.parentRepo.manager.transaction(async (entityManager) => {
            var _a;
            let parent = await entityManager.findOne(Parents_1.Parents, {
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
                throw Error(parents_constant_1.PARENTS_ERROR_NOT_FOUND);
            }
            parent.active = false;
            await entityManager.save(Parents_1.Parents, parent);
            const user = parent.user;
            user.active = false;
            await entityManager.save(Users_1.Users, user);
            parent = await entityManager.findOne(Parents_1.Parents, {
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
            if ((_a = parent === null || parent === void 0 ? void 0 : parent.updatedByUser) === null || _a === void 0 ? void 0 : _a.password) {
                delete parent.updatedByUser.password;
            }
            return parent;
        });
    }
    async approveAccessRequest(parentCode) {
        return await this.parentRepo.manager.transaction(async (entityManager) => {
            var _a;
            let parent = await entityManager.findOne(Parents_1.Parents, {
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
                throw Error(parents_constant_1.PARENTS_ERROR_NOT_FOUND);
            }
            await entityManager.save(Parents_1.Parents, parent);
            parent = await entityManager.findOne(Parents_1.Parents, {
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
            if ((_a = parent === null || parent === void 0 ? void 0 : parent.updatedByUser) === null || _a === void 0 ? void 0 : _a.password) {
                delete parent.updatedByUser.password;
            }
            return parent;
        });
    }
};
ParentsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(Parents_1.Parents)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], ParentsService);
exports.ParentsService = ParentsService;
//# sourceMappingURL=parents.service.js.map