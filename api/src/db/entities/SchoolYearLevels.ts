import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from "typeorm";
import { Users } from "./Users";
import { Schools } from "./Schools";
import { Sections } from "./Sections";
import { Students } from "./Students";

@Index("SchoolYearLevels_pkey", ["schoolYearLevelId"], { unique: true })
@Entity("SchoolYearLevels", { schema: "dbo" })
export class SchoolYearLevels {
  @PrimaryGeneratedColumn({ type: "bigint", name: "SchoolYearLevelId" })
  schoolYearLevelId: string;

  @Column("character varying", { name: "SchoolYearLevelCode", nullable: true })
  schoolYearLevelCode: string | null;

  @Column("character varying", { name: "Name", nullable: true })
  name: string | null;

  @Column("boolean", {
    name: "CanSelectCourses",
    nullable: true,
    default: () => "false",
  })
  canSelectCourses: boolean | null;

  @Column("timestamp with time zone", {
    name: "CreatedDate",
    default: () => "(now() AT TIME ZONE 'Asia/Manila')",
  })
  createdDate: Date;

  @Column("timestamp with time zone", { name: "UpdatedDate", nullable: true })
  updatedDate: Date | null;

  @Column("boolean", { name: "Active", default: () => "true" })
  active: boolean;

  @ManyToOne(() => Users, (users) => users.schoolYearLevels)
  @JoinColumn([{ name: "CreatedByUserId", referencedColumnName: "userId" }])
  createdByUser: Users;

  @ManyToOne(() => Schools, (schools) => schools.schoolYearLevels)
  @JoinColumn([{ name: "SchoolId", referencedColumnName: "schoolId" }])
  school: Schools;

  @ManyToOne(() => Users, (users) => users.schoolYearLevels2)
  @JoinColumn([{ name: "UpdatedByUserId", referencedColumnName: "userId" }])
  updatedByUser: Users;

  @OneToMany(() => Sections, (sections) => sections.schoolYearLevel)
  sections: Sections[];

  @OneToMany(() => Students, (students) => students.schoolYearLevel)
  students: Students[];
}
