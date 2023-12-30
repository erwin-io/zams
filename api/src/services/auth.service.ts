/* eslint-disable no-var */
/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable prettier/prettier */
import { Injectable, UnauthorizedException } from "@nestjs/common";
import { JwtPayload } from "../core/interfaces/payload.interface";
import { JwtService } from "@nestjs/jwt";
import * as fs from "fs";
import * as path from "path";
import {
  compare,
  generateIndentityCode,
  getFullName,
  hash,
} from "src/common/utils/utils";
import { InjectRepository } from "@nestjs/typeorm";
import { FindOneOptions, Repository } from "typeorm";
import moment from "moment";
import { Users } from "src/db/entities/Users";
import { LOGIN_ERROR_PASSWORD_INCORRECT, LOGIN_ERROR_PENDING_ACCESS_REQUEST, LOGIN_ERROR_USERTYPE_INCORRECT, LOGIN_ERROR_USER_NOT_FOUND } from "src/common/constant/auth-error.constant";

import { Students } from "src/db/entities/Students";
import { Employees } from "src/db/entities/Employees";
import { Operators } from "src/db/entities/Operators";
import { RegisterStudentUserDto } from "src/core/dto/auth/register-student.dto";
import { RegisterEmployeeUserDto } from "src/core/dto/auth/register-employee.dto";
import { RegisterOperatorUserDto } from "src/core/dto/auth/register-operator.dto";
import { COURSES_ERROR_NOT_FOUND } from "src/common/constant/courses.constant";
import { SCHOOLS_ERROR_NOT_FOUND } from "src/common/constant/schools.constant";
import { SECTIONS_ERROR_NOT_FOUND } from "src/common/constant/sections.constant";
import { STUDENTS_ERROR_NOT_FOUND } from "src/common/constant/students.constant";
import { CONST_QUERYCURRENT_TIMESTAMP } from "src/common/constant/timestamp.constant";
import { Courses } from "src/db/entities/Courses";
import { Departments } from "src/db/entities/Departments";
import { Schools } from "src/db/entities/Schools";
import { Sections } from "src/db/entities/Sections";
import { StudentCourse } from "src/db/entities/StudentCourse";
import { StudentSection } from "src/db/entities/StudentSection";
import { DEPARTMENTS_ERROR_NOT_FOUND } from "src/common/constant/departments.constant";
import { SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND } from "src/common/constant/school-year-levels.constant";
import { EmployeeRoles } from "src/db/entities/EmployeeRoles";
import { EmployeeTitles } from "src/db/entities/EmployeeTitles";
import { USER_TYPE } from "src/common/constant/user-type.constant";
import { SchoolYearLevels } from "src/db/entities/SchoolYearLevels";
import { Parents } from "src/db/entities/Parents";
import { RegisterParentUserDto } from "src/core/dto/auth/register-parent.dto";
import { EmployeeUser } from "src/db/entities/EmployeeUser";
import { EMPLOYEEROLES_ERROR_NOT_FOUND } from "src/common/constant/employees-roles.constant";

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Users) private readonly userRepo: Repository<Users>,
    private readonly jwtService: JwtService
  ) {}

  async getOperatorsByCredentials(userName, password) {
    let operator = await this.userRepo.manager.findOne(Operators, {
      where: {
        user: {
          userName,
          active: true,
        }
      },
      relations: {
        user: true,
      }
    });
    if (!operator) {
      throw Error(LOGIN_ERROR_USER_NOT_FOUND);
    }
    const passwordMatch = await compare(operator.user.password, password);
    if (!passwordMatch) {
      throw Error(LOGIN_ERROR_PASSWORD_INCORRECT);
    }
    if(!operator.accessGranted) {
      throw Error(LOGIN_ERROR_PENDING_ACCESS_REQUEST);
    }
    delete operator.user.password;
    return operator;
  }

  async getEmployeesByCredentials({userName, password, schoolCode }) {
    let employeeUser = await this.userRepo.manager.findOne(EmployeeUser, {
      where: {
        user: {
          userName,
          active: true,
        },
        employee: {
          school: {
            schoolCode
          }
        }
      },
      relations: {
        user: true,
        employee: {
          department: true,
          createdByUser: true,
          updatedByUser: true,
          school: true,
          employeePosition: true,
          employeeUser: {
            user: true,
            employeeRole: true,
          },
        },
      }
    });
    if (!employeeUser) {
      throw Error(LOGIN_ERROR_USER_NOT_FOUND);
    }
    const passwordMatch = await compare(employeeUser.user.password, password);
    if (!passwordMatch) {
      throw Error(LOGIN_ERROR_PASSWORD_INCORRECT);
    }
    if(!employeeUser.employee.accessGranted) {
      throw Error(LOGIN_ERROR_PENDING_ACCESS_REQUEST);
    }
    delete employeeUser.user.password;
    return employeeUser;
  }

  async getParentsByCredentials(userName, password) {
    const parent = await this.userRepo.manager.findOne(Parents, {
      where: {
        user: {
          userName,
        }
      },
      relations: {
        parentStudents: true,
        registeredByUser: true,
        updatedByUser: true,
        user: {
          userProfilePic: {
            file: true,
          },
        },
      }
    });
    if (!parent) {
      throw Error(LOGIN_ERROR_USER_NOT_FOUND);
    }
    const passwordMatch = await compare(parent.user.password, password);
    if (!passwordMatch) {
      throw Error(LOGIN_ERROR_PASSWORD_INCORRECT);
    }
    delete parent.user.password;
    delete parent.registeredByUser.password;
    if (parent?.updatedByUser?.password) {
      delete parent.updatedByUser.password;
    }
    return parent;
  }

  async getByCredentials({userName, password}) {
    try {
      let user = await this.userRepo.findOne({
        where: {
          userName,
          active: true,
        },
      });
      if (!user) {
        throw Error(LOGIN_ERROR_USER_NOT_FOUND);
      }

      const passwordMatch = await compare(user.password, password);
      if (!passwordMatch) {
        throw Error(LOGIN_ERROR_PASSWORD_INCORRECT);
      }
      if(user.userType === USER_TYPE.PARENT) {
        const parent = await this.userRepo.manager.findOne(Parents, {
          where: {
            user: {
              userId: user.userId,
            }
          },
          relations: {
            parentStudents: true,
            registeredByUser: true,
            updatedByUser: true,
            user: true,
          }
        })
        delete parent.user.password;
        delete parent.registeredByUser.password;
        if (parent?.updatedByUser?.password) {
          delete parent.updatedByUser.password;
        }
        return parent;
      } else if(user.userType === USER_TYPE.EMPLOYEE) {
        const employee = await this.userRepo.manager.findOne(Employees, {
          where: {
            employeeUser: {
              user: {
                userName
              }
            }
          },
          relations: {
            createdByUser: true,
            employeePosition: true,
            school: true,
            updatedByUser: true,
            employeeUser: {
              employeeRole: true,
              user: true
            },
          }
        })
        if(!employee.accessGranted) {
          throw Error(LOGIN_ERROR_PENDING_ACCESS_REQUEST);
        }
        delete employee.employeeUser?.user?.password;
        delete employee.createdByUser.password;
        if (employee?.updatedByUser?.password) {
          delete employee.updatedByUser.password;
        }
        return employee;
      } else if(user.userType === USER_TYPE.OPERATOR) {
        const operator = await this.userRepo.manager.findOne(Operators, {
          where: {
            user: {
              userId: user.userId,
            }
          },
          relations: {
            user: true,
          }
        })
        if(!operator.accessGranted) {
          throw Error(LOGIN_ERROR_PENDING_ACCESS_REQUEST);
        }
        delete operator.user.password;
        return operator;
      } else {
        throw Error(LOGIN_ERROR_USERTYPE_INCORRECT);
      }
    } catch(ex) {
      throw ex;
    }
  }

  async getUserById(userId) {
    try {
      let user = await this.userRepo.findOne({
        where: {
          userId,
          active: true,
        },
      });
      if (!user) {
        throw Error(LOGIN_ERROR_USER_NOT_FOUND);
      }
      if(user.userType === USER_TYPE.EMPLOYEE) {
        const employee = await this.userRepo.manager.findOne(Employees, {
          where: {
            employeeUser: {
              user: {
                userId: user.userId,
              }
            }
          },
          relations: {
            createdByUser: true,
            employeePosition: true,
            school: true,
            updatedByUser: true,
            employeeUser: {
              user: true,
              employeeRole: true,
            },
          }
        })
        if(!employee.accessGranted) {
          throw Error(LOGIN_ERROR_PENDING_ACCESS_REQUEST);
        }
        delete employee.employeeUser.user.password;
        return employee.employeeUser?.user;
      } else if(user.userType === USER_TYPE.PARENT) {
        const parent = await this.userRepo.manager.findOne(Parents, {
          where: {
            user: {
              userId: user.userId,
            }
          },
          relations: {
            parentStudents: true,
            registeredByUser: true,
            updatedByUser: true,
            user: true,
          }
        })
        delete parent.user.password;
        delete parent.registeredByUser.password;
        if (parent?.updatedByUser?.password) {
          delete parent.updatedByUser.password;
        }
        return parent.user;
      } else {
        const operator = await this.userRepo.manager.findOne(Operators, {
          where: {
            user: {
              userId: user.userId,
            }
          },
          relations: {
            user: true,
          }
        })
        if(!operator.accessGranted) {
          throw Error(LOGIN_ERROR_PENDING_ACCESS_REQUEST);
        }
        delete operator.user.password;
        return operator.user;
      }
    } catch(ex) {
      throw ex;
    }
  }

  // async registerStudent(dto: RegisterStudentUserDto) {
  //   try {
  //     return await this.userRepo.manager.transaction(async (entityManager) => {
  //       const school = await entityManager.findOne(Schools, {
  //         where: {
  //           schoolId: dto.schoolId,
  //           active: true,
  //         },
  //       });
  //       if (!school) {
  //         throw Error(SCHOOLS_ERROR_NOT_FOUND);
  //       }
  
  //       let student = new Students();
  //       student.school = school;
  //       student.accessGranted = false;
  //       student.firstName = dto.firstName;
  //       student.middleInitial = dto.middleInitial;
  //       student.lastName = dto.lastName;
  //       student.fullName = `${dto.firstName} ${dto.lastName}`;
  //       student.email = dto.email;
  //       student.mobileNumber = dto.mobileNumber;
  //       student.birthDate = moment(dto.birthDate).format("YYYY-MM-DD");
  //       student.lrn = dto.lrn;
  //       student.cardNumber = dto.cardNumber;
  //       student.gender = dto.gender;
  //       student.address = dto.address;
  //       const timestamp = await entityManager
  //         .query(CONST_QUERYCURRENT_TIMESTAMP)
  //         .then((res) => {
  //           return res[0]["timestamp"];
  //         });
  //       student.registrationDate = timestamp;
  
  //       const department = await entityManager.findOne(Departments, {
  //         where: {
  //           departmentId: dto.departmentId,
  //           active: true,
  //         },
  //       });
  //       if (!department) {
  //         throw Error(STUDENTS_ERROR_NOT_FOUND);
  //       }
  //       student.department = department;
  
  //       const schoolYearLevel = await entityManager.findOne(SchoolYearLevels, {
  //         where: {
  //           school: {
  //             schoolId: dto.schoolId
  //           },
  //           active: true,
  //         },
  //       });
  //       if (!schoolYearLevel) {
  //         throw Error(SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND);
  //       }
  //       student.schoolYearLevel = schoolYearLevel;
  
  //       student = await entityManager.save(Students, student);
  //       student.studentCode = generateIndentityCode(student.studentId);
  //       student = await entityManager.save(Students, student);
  
  //       const studentCourse = new StudentCourse();
  //       studentCourse.student = student;
  //       const course = await entityManager.findOne(Courses, {
  //         where: {
  //           courseId: dto.courseId,
  //           active: true,
  //         },
  //       });
  //       if (!course) {
  //         throw Error(COURSES_ERROR_NOT_FOUND);
  //       }
  //       studentCourse.course = course;
  //       await entityManager.save(StudentCourse, studentCourse);
  
  //       const studentSection = new StudentSection();
  //       studentSection.student = student;
  //       const section = await entityManager.findOne(Sections, {
  //         where: {
  //           sectionId: dto.sectionId,
  //           active: true,
  //         },
  //       });
  //       if (!section) {
  //         throw Error(SECTIONS_ERROR_NOT_FOUND);
  //       }
  //       studentSection.section = section;
  //       await entityManager.save(StudentSection, studentSection);
  
  //       student = await entityManager.findOne(Students, {
  //         where: {
  //           studentCode: student.studentCode,
  //           active: true,
  //         },
  //         relations: {
  //           parentStudents: {
  //             parent: true,
  //           },
  //           studentCourses: {
  //             course: true,
  //           },
  //           department: true,
  //           registeredByUser: true,
  //           updatedByUser: true,
  //           school: true,
  //           schoolYearLevel: true,
  //           studentSections: {
  //             section: true,
  //           },
  //         },
  //       });
  //       delete student.registeredByUser.password;
  //       if (student?.updatedByUser?.password) {
  //         delete student.updatedByUser.password;
  //       }
  //       return student;
  //     });
  //   } catch (ex) {
  //     if (
  //       ex["message"] &&
  //       (ex["message"].includes("duplicate key") ||
  //         ex["message"].includes("violates unique constraint")) &&
  //       ex["message"].includes("u_user")
  //     ) {
  //       throw Error("Username already used!");
  //     } else {
  //       throw ex;
  //     }
  //   }
  // }

  async registerEmployee(dto: RegisterEmployeeUserDto) {
    try {
      return await this.userRepo.manager.transaction(
        async (entityManager) => {
          const school = await entityManager.findOne(Schools, {
            where: {
              schoolId: dto.schoolId,
              active: true,
            },
          });
          if (!school) {
            throw Error(SCHOOLS_ERROR_NOT_FOUND);
          }
  
          let user = new Users();
          user.userType = USER_TYPE.EMPLOYEE;
          user.userName = dto.userName;
          user.password = await hash(dto.password);
          user = await entityManager.save(Users, user);
  
          let employee = new Employees();
          employee.school = school;
          employee.accessGranted = false;
          employee.firstName = dto.firstName;
          employee.middleInitial = dto.middleInitial;
          employee.lastName = dto.lastName;
          employee.fullName = `${dto.firstName} ${dto.lastName}`;
          employee.mobileNumber = dto.mobileNumber;
          employee.cardNumber = dto.cardNumber;
          const timestamp = await entityManager
            .query(CONST_QUERYCURRENT_TIMESTAMP)
            .then((res) => {
              return res[0]["timestamp"];
            });
          employee.createdDate = timestamp;
          employee.createdByUser = user;
  
          const department = await entityManager.findOne(Departments, {
            where: {
              departmentId: dto.departmentId,
              school: {
                schoolId: dto.schoolId,
              },
              active: true,
            },
          });
          if (!department) {
            throw Error(DEPARTMENTS_ERROR_NOT_FOUND);
          }
          employee.department = department;
  
          const employeePosition = await entityManager.findOne(EmployeeTitles, {
            where: {
              employeeTitleId: dto.employeeTitleId,
              school: {
                schoolId: dto.schoolId,
              },
              active: true,
            },
          });
          if (!employeePosition) {
            throw Error(SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND);
          }
          employee.employeePosition = employeePosition;
  
          employee = await entityManager.save(Employees, employee);
          employee.employeeCode = generateIndentityCode(employee.employeeId);
          employee = await entityManager.save(Employees, employee);
  
          let employeeUser = new EmployeeUser();
          employeeUser.user = user;
          employeeUser.employee = employee;
          employeeUser.dateRegistered = timestamp;
          employeeUser = await entityManager.save(EmployeeUser, employeeUser);

          employee = await entityManager.findOne(Employees, {
            where: {
              employeeCode: employee.employeeCode,
              active: true,
            },
            relations: {
              department: true,
              createdByUser: true,
              updatedByUser: true,
              school: true,
              employeePosition: true,
              employeeUser: {
                user: true,
                employeeRole: true,
              },
            },
          });
          delete employee.employeeUser?.user?.password;
          delete employee.createdByUser.password;
          return employee;
        }
      );
    } catch (ex) {
      if (
        ex["message"] &&
        (ex["message"].includes("duplicate key") ||
          ex["message"].includes("violates unique constraint")) &&
        ex["message"].includes("u_user")
      ) {
        throw Error("Username already used!");
      } else {
        throw ex;
      }
    }
  }

  async registerParent(dto: RegisterParentUserDto) {
    try {
      return await this.userRepo.manager.transaction(
        async (entityManager) => {
          let user = new Users();
          user.userType = USER_TYPE.PARENT;
          user.userName = dto.userName;
          user.password = await hash(dto.password);
          user = await entityManager.save(Users, user);
  
          let parent = new Parents();
          parent.user = user;
          parent.firstName = dto.firstName;
          parent.middleInitial = dto.middleInitial;
          parent.lastName = dto.lastName;
          parent.fullName = `${dto.firstName} ${dto.lastName}`;
          parent.mobileNumber = dto.mobileNumber;
          parent.birthDate = moment(dto.birthDate.toString()).format("YYYY-MM-DD");
          parent.gender = dto.gender;
          parent.address = dto.address;
          const timestamp = await entityManager
            .query(CONST_QUERYCURRENT_TIMESTAMP)
            .then((res) => {
              return res[0]["timestamp"];
            });
          parent.registrationDate = timestamp;
          parent.registeredByUser = user;

          parent = await entityManager.save(Parents, parent);
          parent.parentCode = generateIndentityCode(parent.parentId);
          parent = await entityManager.save(Parents, parent);
          parent = await entityManager.findOne(Parents, {
            where: {
              parentCode: parent.parentCode,
              active: true,
            },
            relations: {
              parentStudents: true,
              registeredByUser: true,
              updatedByUser: true,
              user: true,
            },
          });
          delete parent.user.password;
          delete parent.registeredByUser.password;
          return parent;
        }
      );
    } catch (ex) {
      if (
        ex["message"] &&
        (ex["message"].includes("duplicate key") ||
          ex["message"].includes("violates unique constraint")) &&
        ex["message"].includes("u_user")
      ) {
        throw Error("Username already used!");
      } else if (
        ex["message"] &&
        (ex["message"].includes("duplicate key") ||
          ex["message"].includes("violates unique constraint")) &&
        ex["message"].includes("u_parents_number")
      ) {
        throw Error("Number already used!");
      } else {
        throw ex;
      }
    }
  }

  async registerOperator(dto: RegisterOperatorUserDto) {
    try {
      return await this.userRepo.manager.transaction(
        async (entityManager) => {
          let user = new Users();
          user.userType = USER_TYPE.OPERATOR;
          user.userName = dto.userName;
          user.password = await hash(dto.password);
          user = await entityManager.save(Users, user);
  
          let operator = new Operators();
          operator.user = user;
          operator.accessGranted = false;
          operator.name = dto.name;
  
          operator = await entityManager.save(Operators, operator);
          operator.operatorCode = generateIndentityCode(operator.operatorId);
          operator = await entityManager.save(Operators, operator);
          operator = await entityManager.findOne(Operators, {
            where: {
              operatorCode: operator.operatorCode,
              active: true,
            },
            relations: {
              user: true,
            },
          });
          delete operator.user.password;
          return operator;
        }
      );
    } catch (ex) {
      if (
        ex["message"] &&
        (ex["message"].includes("duplicate key") ||
          ex["message"].includes("violates unique constraint")) &&
        ex["message"].includes("u_user")
      ) {
        throw Error("Username already used!");
      } else {
        throw ex;
      }
    }
  }
}
