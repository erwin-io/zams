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
import { TapLogs } from "./TapLogs";

@Index("u_machine_desc", ["active", "description"], { unique: true })
@Index("Machines_pkey", ["machineId"], { unique: true })
@Entity("Machines", { schema: "dbo" })
export class Machines {
  @PrimaryGeneratedColumn({ type: "bigint", name: "MachineId" })
  machineId: string;

  @Column("character varying", { name: "MachineCode", nullable: true })
  machineCode: string | null;

  @Column("character varying", { name: "Description" })
  description: string;

  @Column("character varying", { name: "Path" })
  path: string;

  @Column("character varying", { name: "Domain" })
  domain: string;

  @Column("timestamp with time zone", {
    name: "CreatedDate",
    default: () => "(now() AT TIME ZONE 'Asia/Manila')",
  })
  createdDate: Date;

  @Column("timestamp with time zone", { name: "UpdatedDate", nullable: true })
  updatedDate: Date | null;

  @Column("boolean", { name: "Active", default: () => "true" })
  active: boolean;

  @ManyToOne(() => Users, (users) => users.machines)
  @JoinColumn([{ name: "CreatedByUserId", referencedColumnName: "userId" }])
  createdByUser: Users;

  @ManyToOne(() => Schools, (schools) => schools.machines)
  @JoinColumn([{ name: "SchoolId", referencedColumnName: "schoolId" }])
  school: Schools;

  @ManyToOne(() => Users, (users) => users.machines2)
  @JoinColumn([{ name: "UpdatedByUserId", referencedColumnName: "userId" }])
  updatedByUser: Users;

  @OneToMany(() => TapLogs, (tapLogs) => tapLogs.machine)
  tapLogs: TapLogs[];
}
