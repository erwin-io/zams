import { Users } from "./Users";
import { Schools } from "./Schools";
import { Students } from "./Students";
export declare class ParentStudentRequest {
    parentStudentRequestId: string;
    status: string;
    dateRequested: Date;
    updatedDate: Date | null;
    notes: string | null;
    requestedByUser: Users;
    school: Schools;
    student: Students;
    updatedByUser: Users;
}
