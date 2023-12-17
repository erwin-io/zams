"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LinkStudentRequestModule = void 0;
const common_1 = require("@nestjs/common");
const link_student_request_controller_1 = require("./link-student-request.controller");
const link_student_request_service_1 = require("../../services/link-student-request.service");
const typeorm_1 = require("@nestjs/typeorm");
const LinkStudentRequest_1 = require("../../db/entities/LinkStudentRequest");
const pusher_service_1 = require("../../services/pusher.service");
let LinkStudentRequestModule = class LinkStudentRequestModule {
};
LinkStudentRequestModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([LinkStudentRequest_1.LinkStudentRequest])],
        controllers: [link_student_request_controller_1.LinkStudentRequestController],
        providers: [link_student_request_service_1.LinkStudentRequestService, pusher_service_1.PusherService],
        exports: [link_student_request_service_1.LinkStudentRequestService, pusher_service_1.PusherService],
    })
], LinkStudentRequestModule);
exports.LinkStudentRequestModule = LinkStudentRequestModule;
//# sourceMappingURL=link-student-request.module.js.map