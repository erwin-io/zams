import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
} from "typeorm";
import { LinkStudentRequest } from "./LinkStudentRequest";
import { ParentStudent } from "./ParentStudent";
import { StudentCourse } from "./StudentCourse";
import { StudentSection } from "./StudentSection";
import { Departments } from "./Departments";
import { Users } from "./Users";
import { Schools } from "./Schools";
import { SchoolYearLevels } from "./SchoolYearLevels";
import { TapLogs } from "./TapLogs";

@Index("u_students_card", ["active", "cardNumber"], { unique: true })
@Index("u_students_number", ["active", "mobileNumber"], { unique: true })
@Index("u_students_email", ["active", "email"], { unique: true })
@Index("Students_pkey", ["studentId"], { unique: true })
@Entity("Students", { schema: "dbo" })
export class Students {
  @PrimaryGeneratedColumn({ type: "bigint", name: "StudentId" })
  studentId: string;

  @Column("character varying", { name: "StudentCode", nullable: true })
  studentCode: string | null;

  @Column("character varying", { name: "FirstName" })
  firstName: string;

  @Column("character varying", { name: "MiddleInitial", nullable: true })
  middleInitial: string | null;

  @Column("character varying", { name: "LastName" })
  lastName: string;

  @Column("character varying", { name: "LRN" })
  lrn: string;

  @Column("character varying", { name: "CardNumber" })
  cardNumber: string;

  @Column("date", { name: "BirthDate", nullable: true })
  birthDate: string | null;

  @Column("character varying", { name: "MobileNumber" })
  mobileNumber: string;

  @Column("character varying", { name: "Email", nullable: true })
  email: string | null;

  @Column("character varying", { name: "Address", nullable: true })
  address: string | null;

  @Column("character varying", {
    name: "Gender",
    nullable: true,
    default: () => "'Others'",
  })
  gender: string | null;

  @Column("boolean", {
    name: "AccessGranted",
    nullable: true,
    default: () => "false",
  })
  accessGranted: boolean | null;

  @Column("timestamp with time zone", {
    name: "RegistrationDate",
    default: () => "(now() AT TIME ZONE 'Asia/Manila')",
  })
  registrationDate: Date;

  @Column("timestamp with time zone", { name: "UpdatedDate", nullable: true })
  updatedDate: Date | null;

  @Column("boolean", { name: "Active", default: () => "true" })
  active: boolean;

  @Column("character varying", { name: "FullName", default: () => "''" })
  fullName: string;

  @Column("character varying", { name: "OrgStudentId" })
  orgStudentId: string;

  @OneToMany(
    () => LinkStudentRequest,
    (linkStudentRequest) => linkStudentRequest.student
  )
  linkStudentRequests: LinkStudentRequest[];

  @OneToMany(() => ParentStudent, (parentStudent) => parentStudent.student)
  parentStudents: ParentStudent[];

  @OneToOne(() => StudentCourse, (studentCourse) => studentCourse.student)
  studentCourse: StudentCourse;

  @OneToOne(() => StudentSection, (studentSection) => studentSection.student)
  studentSection: StudentSection;

  @ManyToOne(() => Departments, (departments) => departments.students)
  @JoinColumn([{ name: "DepartmentId", referencedColumnName: "departmentId" }])
  department: Departments;

  @ManyToOne(() => Users, (users) => users.students)
  @JoinColumn([{ name: "RegisteredByUserId", referencedColumnName: "userId" }])
  registeredByUser: Users;

  @ManyToOne(() => Schools, (schools) => schools.students)
  @JoinColumn([{ name: "SchoolId", referencedColumnName: "schoolId" }])
  school: Schools;

  @ManyToOne(
    () => SchoolYearLevels,
    (schoolYearLevels) => schoolYearLevels.students
  )
  @JoinColumn([
    { name: "SchoolYearLevelId", referencedColumnName: "schoolYearLevelId" },
  ])
  schoolYearLevel: SchoolYearLevels;

  @ManyToOne(() => Users, (users) => users.students2)
  @JoinColumn([{ name: "UpdatedByUserId", referencedColumnName: "userId" }])
  updatedByUser: Users;

  @OneToMany(() => TapLogs, (tapLogs) => tapLogs.student)
  tapLogs: TapLogs[];
}
