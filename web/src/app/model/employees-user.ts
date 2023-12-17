import { Employees } from "./Employees";
import { EmployeeRoles } from "./employee-roles";
import { Schools } from "./schools";
import { Users } from "./users";

export class EmployeeUser {
  employee: Employees;
  department: Users;
  employeeRole: EmployeeRoles;
}
