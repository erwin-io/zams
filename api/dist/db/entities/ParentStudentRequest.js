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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ParentStudentRequest = void 0;
const typeorm_1 = require("typeorm");
const Users_1 = require("./Users");
const Schools_1 = require("./Schools");
const Students_1 = require("./Students");
let ParentStudentRequest = class ParentStudentRequest {
};
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)({ type: "bigint", name: "ParentStudentRequestId" }),
    __metadata("design:type", String)
], ParentStudentRequest.prototype, "parentStudentRequestId", void 0);
__decorate([
    (0, typeorm_1.Column)("character varying", { name: "Status" }),
    __metadata("design:type", String)
], ParentStudentRequest.prototype, "status", void 0);
__decorate([
    (0, typeorm_1.Column)("timestamp with time zone", {
        name: "DateRequested",
        default: () => "(now() AT TIME ZONE 'Asia/Manila')",
    }),
    __metadata("design:type", Date)
], ParentStudentRequest.prototype, "dateRequested", void 0);
__decorate([
    (0, typeorm_1.Column)("timestamp with time zone", { name: "UpdatedDate", nullable: true }),
    __metadata("design:type", Date)
], ParentStudentRequest.prototype, "updatedDate", void 0);
__decorate([
    (0, typeorm_1.Column)("character varying", { name: "Notes", nullable: true }),
    __metadata("design:type", String)
], ParentStudentRequest.prototype, "notes", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => Users_1.Users, (users) => users.parentStudentRequests),
    (0, typeorm_1.JoinColumn)([{ name: "RequestedByUserId", referencedColumnName: "userId" }]),
    __metadata("design:type", Users_1.Users)
], ParentStudentRequest.prototype, "requestedByUser", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => Schools_1.Schools, (schools) => schools.parentStudentRequests),
    (0, typeorm_1.JoinColumn)([{ name: "SchoolId", referencedColumnName: "schoolId" }]),
    __metadata("design:type", Schools_1.Schools)
], ParentStudentRequest.prototype, "school", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => Students_1.Students, (students) => students.parentStudentRequests),
    (0, typeorm_1.JoinColumn)([{ name: "StudentId", referencedColumnName: "studentId" }]),
    __metadata("design:type", Students_1.Students)
], ParentStudentRequest.prototype, "student", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => Users_1.Users, (users) => users.parentStudentRequests2),
    (0, typeorm_1.JoinColumn)([{ name: "UpdatedByUserId", referencedColumnName: "userId" }]),
    __metadata("design:type", Users_1.Users)
], ParentStudentRequest.prototype, "updatedByUser", void 0);
ParentStudentRequest = __decorate([
    (0, typeorm_1.Index)("ParentStudentRequest_pkey", ["parentStudentRequestId"], {
        unique: true,
    }),
    (0, typeorm_1.Entity)("ParentStudentRequest", { schema: "dbo" })
], ParentStudentRequest);
exports.ParentStudentRequest = ParentStudentRequest;
//# sourceMappingURL=ParentStudentRequest.js.map