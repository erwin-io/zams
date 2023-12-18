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
exports.UserFirebaseTokentService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const ueserFirebaseTokens_constant_1 = require("src/common/constant/ueserFirebaseTokens.constant");
const schools_constant_1 = require("../common/constant/schools.constant");
const timestamp_constant_1 = require("../common/constant/timestamp.constant");
const user_error_constant_1 = require("../common/constant/user-error.constant");
const utils_1 = require("../common/utils/utils");
const Schools_1 = require("../db/entities/Schools");
const UserFirebaseToken_1 = require("../db/entities/UserFirebaseToken");
const Users_1 = require("../db/entities/Users");
const typeorm_2 = require("typeorm");
let UserFirebaseTokentService = class UserFirebaseTokentService {
    constructor(ueserFirebaseTokensRepo) {
        this.ueserFirebaseTokensRepo = ueserFirebaseTokensRepo;
    }
    async getByUserDevice(userId) {
        var _a;
        const result = await this.ueserFirebaseTokensRepo.findOne({
            where: {
                ueserFirebaseTokenCode,
                active: true,
            },
            relations: {
                createdByUser: true,
                updatedByUser: true,
            },
        });
        if (!result) {
            throw Error(ueserFirebaseTokens_constant_1.USER_FIREBASE_TOKEN_ERROR_USER_NOT_FOUND);
        }
        delete result.createdByUser.password;
        if ((_a = result === null || result === void 0 ? void 0 : result.updatedByUser) === null || _a === void 0 ? void 0 : _a.password) {
            delete result.updatedByUser.password;
        }
        return result;
    }
    async create(dto) {
        return await this.ueserFirebaseTokensRepo.manager.transaction(async (entityManager) => {
            let ueserFirebaseTokens = new UserFirebaseToken_1.UserFirebaseToken();
            ueserFirebaseTokens.ueserFirebaseTokenName = dto.ueserFirebaseTokenName;
            const timestamp = await entityManager
                .query(timestamp_constant_1.CONST_QUERYCURRENT_TIMESTAMP)
                .then((res) => {
                return res[0]["timestamp"];
            });
            ueserFirebaseTokens.createdDate = timestamp;
            const school = await entityManager.findOne(Schools_1.Schools, {
                where: {
                    schoolId: dto.schoolId,
                    active: true,
                },
            });
            if (!school) {
                throw Error(schools_constant_1.SCHOOLS_ERROR_NOT_FOUND);
            }
            ueserFirebaseTokens.school = school;
            const createdByUser = await entityManager.findOne(Users_1.Users, {
                where: {
                    userId: dto.createdByUserId,
                    active: true,
                },
            });
            if (!createdByUser) {
                throw Error(user_error_constant_1.USER_ERROR_USER_NOT_FOUND);
            }
            ueserFirebaseTokens.createdByUser = createdByUser;
            ueserFirebaseTokens = await entityManager.save(ueserFirebaseTokens);
            ueserFirebaseTokens.ueserFirebaseTokenCode = (0, utils_1.generateIndentityCode)(ueserFirebaseTokens.ueserFirebaseTokenId);
            ueserFirebaseTokens = await entityManager.save(UserFirebaseToken_1.UserFirebaseToken, ueserFirebaseTokens);
            delete ueserFirebaseTokens.createdByUser.password;
            return ueserFirebaseTokens;
        });
    }
    async update(ueserFirebaseTokenCode, dto) {
        return await this.ueserFirebaseTokensRepo.manager.transaction(async (entityManager) => {
            var _a, _b;
            let ueserFirebaseTokens = await entityManager.findOne(UserFirebaseToken_1.UserFirebaseToken, {
                where: {
                    ueserFirebaseTokenCode,
                    active: true,
                },
            });
            if (!ueserFirebaseTokens) {
                throw Error(ueserFirebaseTokens_constant_1.USER_FIREBASE_TOKEN_ERROR_USER_NOT_FOUND);
            }
            const timestamp = await entityManager
                .query(timestamp_constant_1.CONST_QUERYCURRENT_TIMESTAMP)
                .then((res) => {
                return res[0]["timestamp"];
            });
            ueserFirebaseTokens.updatedDate = timestamp;
            const updatedByUser = await entityManager.findOne(Users_1.Users, {
                where: {
                    userId: dto.updatedByUserId,
                    active: true,
                },
            });
            if (!updatedByUser) {
                throw Error(user_error_constant_1.USER_ERROR_USER_NOT_FOUND);
            }
            ueserFirebaseTokens.updatedByUser = updatedByUser;
            ueserFirebaseTokens.ueserFirebaseTokenName = dto.ueserFirebaseTokenName;
            ueserFirebaseTokens = await entityManager.save(UserFirebaseToken_1.UserFirebaseToken, ueserFirebaseTokens);
            if ((_a = ueserFirebaseTokens === null || ueserFirebaseTokens === void 0 ? void 0 : ueserFirebaseTokens.createdByUser) === null || _a === void 0 ? void 0 : _a.password) {
                delete ueserFirebaseTokens.createdByUser.password;
            }
            if ((_b = ueserFirebaseTokens === null || ueserFirebaseTokens === void 0 ? void 0 : ueserFirebaseTokens.updatedByUser) === null || _b === void 0 ? void 0 : _b.password) {
                delete ueserFirebaseTokens.updatedByUser.password;
            }
            return ueserFirebaseTokens;
        });
    }
    async delete(ueserFirebaseTokenCode) {
        return await this.ueserFirebaseTokensRepo.manager.transaction(async (entityManager) => {
            const ueserFirebaseTokens = await entityManager.findOne(UserFirebaseToken_1.UserFirebaseToken, {
                where: {
                    ueserFirebaseTokenCode,
                    active: true,
                },
            });
            if (!ueserFirebaseTokens) {
                throw Error(ueserFirebaseTokens_constant_1.USER_FIREBASE_TOKEN_ERROR_USER_NOT_FOUND);
            }
            ueserFirebaseTokens.active = false;
            const timestamp = await entityManager
                .query(timestamp_constant_1.CONST_QUERYCURRENT_TIMESTAMP)
                .then((res) => {
                return res[0]["timestamp"];
            });
            ueserFirebaseTokens.updatedDate = timestamp;
            return await entityManager.save(UserFirebaseToken_1.UserFirebaseToken, ueserFirebaseTokens);
        });
    }
};
UserFirebaseTokentService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(UserFirebaseToken_1.UserFirebaseToken)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], UserFirebaseTokentService);
exports.UserFirebaseTokentService = UserFirebaseTokentService;
//# sourceMappingURL=user-firebase-tokent.service.js.map