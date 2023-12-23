import { Departments } from "./departments";
import { ParentStudent } from "./parent-students";
import { SchoolYearLevels } from "./school-year-levels";
import { Schools } from "./schools";
import { StudentCourse } from "./student-course";
import { StudentSection } from "./student-section";
import { Users } from "./users";

export class Students {
  studentId: string;
  studentCode: string;
  orgStudentId: string;
  firstName: string;
  middleInitial: string;
  lastName: string;
  fullName: string;
  lrn: string;
  cardNumber: string;
  birthDate: string;
  mobileNumber: string;
  email: string;
  address: string;
  gender: string;
  accessGranted: boolean;
  registrationDate: Date;
  updatedDate: Date;
  parentStudents: ParentStudent[];
  registeredByUser: Users;
  updatedByUser: Users;
  active: boolean;
  user: Users;
  school: Schools;
  department: Departments;
  schoolYearLevel: SchoolYearLevels;
  studentCourse: StudentCourse;
  studentSection: StudentSection;
}
