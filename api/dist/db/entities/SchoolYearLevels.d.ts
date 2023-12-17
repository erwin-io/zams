import { Users } from "./Users";
import { Schools } from "./Schools";
import { Sections } from "./Sections";
import { Students } from "./Students";
export declare class SchoolYearLevels {
    schoolYearLevelId: string;
    schoolYearLevelCode: string | null;
    name: string | null;
    canSelectCourses: boolean | null;
    createdDate: Date;
    updatedDate: Date | null;
    active: boolean;
    createdByUser: Users;
    school: Schools;
    updatedByUser: Users;
    sections: Sections[];
    students: Students[];
}
