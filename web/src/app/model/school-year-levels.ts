import { Schools } from "./schools";
import { Users } from "./users";

export class SchoolYearLevels {
  schoolYearLevelId: string;
  schoolYearLevelCode: string;
  name: string;
  canSelectCourses: boolean;
  createdDate: Date;
  updatedDate: Date;
  active: boolean;
  createdByUser: Users;
  school: Schools;
  updatedByUser: Users;
}