import { DefaultDepartmentDto } from "./link-student-request-base.dto";
export declare class CreateDepartmentDto extends DefaultDepartmentDto {
    createdByUserId: string;
    schoolId: string;
}
