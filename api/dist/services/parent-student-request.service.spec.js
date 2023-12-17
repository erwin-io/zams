"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const parent_student_request_service_1 = require("./parent-student-request.service");
describe('ParentStudentRequestService', () => {
    let service;
    beforeEach(async () => {
        const module = await testing_1.Test.createTestingModule({
            providers: [parent_student_request_service_1.ParentStudentRequestService],
        }).compile();
        service = module.get(parent_student_request_service_1.ParentStudentRequestService);
    });
    it('should be defined', () => {
        expect(service).toBeDefined();
    });
});
//# sourceMappingURL=parent-student-request.service.spec.js.map