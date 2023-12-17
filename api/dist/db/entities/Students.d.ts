import { LinkStudentRequest } from "./LinkStudentRequest";
import { ParentStudent } from "./ParentStudent";
import { StudentCourse } from "./StudentCourse";
import { StudentSection } from "./StudentSection";
import { Departments } from "./Departments";
import { Users } from "./Users";
import { Schools } from "./Schools";
import { SchoolYearLevels } from "./SchoolYearLevels";
import { TapLogs } from "./TapLogs";
export declare class Students {
    studentId: string;
    studentCode: string | null;
    firstName: string;
    middleName: string | null;
    lastName: string;
    lrn: string;
    cardNumber: string;
    birthDate: string | null;
    mobileNumber: string;
    email: string | null;
    address: string | null;
    gender: string | null;
    accessGranted: boolean | null;
    registrationDate: Date;
    updatedDate: Date | null;
    active: boolean;
    fullName: string;
    linkStudentRequests: LinkStudentRequest[];
    parentStudents: ParentStudent[];
    studentCourse: StudentCourse;
    studentSection: StudentSection;
    department: Departments;
    registeredByUser: Users;
    school: Schools;
    schoolYearLevel: SchoolYearLevels;
    updatedByUser: Users;
    tapLogs: TapLogs[];
}
