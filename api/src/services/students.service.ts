import {
  columnDefToTypeORMCondition,
  generateIndentityCode,
  hash,
} from "../common/utils/utils";
import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import moment from "moment";
import { COURSES_ERROR_NOT_FOUND } from "src/common/constant/courses.constant";
import { DEPARTMENTS_ERROR_NOT_FOUND } from "src/common/constant/departments.constant";
import { SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND } from "src/common/constant/school-year-levels.constant";
import { SCHOOLS_ERROR_NOT_FOUND } from "src/common/constant/schools.constant";
import { SECTIONS_ERROR_NOT_FOUND } from "src/common/constant/sections.constant";
import { STUDENTS_ERROR_NOT_FOUND } from "src/common/constant/students.constant";
import { CONST_QUERYCURRENT_TIMESTAMP } from "src/common/constant/timestamp.constant";
import { USER_ERROR_USER_NOT_FOUND } from "src/common/constant/user-error.constant";
import { USER_TYPE } from "src/common/constant/user-type.constant";
import { UpdateUserResetPasswordDto } from "src/core/dto/auth/reset-password.dto";
import { CreateStudentDto } from "src/core/dto/students/students.create.dto";
import {
  UpdateStudentUserProfileDto,
  UpdateStudentUserDto,
  UpdateStudentDto,
} from "src/core/dto/students/students.update.dto";
import { FirebaseProvider } from "src/core/provider/firebase/firebase-provider";
import { Courses } from "src/db/entities/Courses";
import { Departments } from "src/db/entities/Departments";
import { ParentStudent } from "src/db/entities/ParentStudent";
import { SchoolYearLevels } from "src/db/entities/SchoolYearLevels";
import { Schools } from "src/db/entities/Schools";
import { Sections } from "src/db/entities/Sections";
import { StudentCourse } from "src/db/entities/StudentCourse";
import { StudentSection } from "src/db/entities/StudentSection";
import { Students } from "src/db/entities/Students";
import { Users } from "src/db/entities/Users";
import { Repository } from "typeorm";

@Injectable()
export class StudentsService {
  constructor(
    @InjectRepository(Students)
    private readonly studentRepo: Repository<Students>
  ) {}

  async getPagination({ pageSize, pageIndex, order, columnDef }) {
    const skip =
      Number(pageIndex) > 0 ? Number(pageIndex) * Number(pageSize) : 0;
    const take = Number(pageSize);
    const condition = columnDefToTypeORMCondition(columnDef);
    const [results, total] = await Promise.all([
      this.studentRepo.find({
        where: {
          ...condition,
          active: true,
        },
        relations: {
          parentStudents: true,
          studentCourse: {
            course: true,
          },
          department: true,
          registeredByUser: true,
          updatedByUser: true,
          school: true,
          schoolYearLevel: true,
          studentSection: {
            section: true,
          },
        },
        skip,
        take,
        order,
      }),
      this.studentRepo.count({
        where: {
          ...condition,
          active: true,
        },
      }),
    ]);
    return {
      results: results.map((x) => {
        delete x.registeredByUser.password;
        if (x?.updatedByUser?.password) {
          delete x.updatedByUser.password;
        }
        return x;
      }),
      total,
    };
  }

  async getByCode(studentCode) {
    const res = await this.studentRepo.findOne({
      where: {
        studentCode,
        active: true,
      },
      relations: {
        parentStudents: {
          parent: true,
        },
        studentCourse: {
          course: true,
        },
        department: true,
        registeredByUser: true,
        updatedByUser: true,
        school: true,
        schoolYearLevel: true,
        studentSection: {
          section: true,
        },
      },
    });

    if (!res) {
      throw Error(USER_ERROR_USER_NOT_FOUND);
    }
    delete res.registeredByUser.password;
    if (res?.updatedByUser?.password) {
      delete res.updatedByUser.password;
    }
    return res;
  }

  async create(dto: CreateStudentDto) {
    try {
      return await this.studentRepo.manager.transaction(
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
          let student = new Students();
          student.school = school;
          student.accessGranted = true;
          student.firstName = dto.firstName;
          student.middleName = dto.middleName;
          student.lastName = dto.lastName;
          student.fullName = `${dto.firstName} ${dto.lastName}`;
          student.email = dto.email;
          student.mobileNumber = dto.mobileNumber;
          student.birthDate = moment(dto.birthDate).format("YYYY-MM-DD");
          student.lrn = dto.lrn;
          student.cardNumber = dto.cardNumber;
          student.gender = dto.gender;
          student.address = dto.address;
          const timestamp = await entityManager
            .query(CONST_QUERYCURRENT_TIMESTAMP)
            .then((res) => {
              return res[0]["timestamp"];
            });
          student.registrationDate = timestamp;

          const registeredByUser = await entityManager.findOne(Users, {
            where: {
              userId: dto.registeredByUserId,
              active: true,
            },
          });
          if (!registeredByUser) {
            throw Error(USER_ERROR_USER_NOT_FOUND);
          }
          student.registeredByUser = registeredByUser;

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
          student.department = department;

          const schoolYearLevel = await entityManager.findOne(
            SchoolYearLevels,
            {
              where: {
                schoolYearLevelId: dto.schoolYearLevelId,
                school: {
                  schoolId: dto.schoolId,
                },
                active: true,
              },
            }
          );
          if (!schoolYearLevel) {
            throw Error(SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND);
          }
          student.schoolYearLevel = schoolYearLevel;

          student = await entityManager.save(Students, student);
          student.studentCode = generateIndentityCode(student.studentId);
          student = await entityManager.save(Students, student);

          const studentSection = new StudentSection();
          studentSection.student = student;
          const section = await entityManager.findOne(Sections, {
            where: {
              sectionId: dto.sectionId,
              active: true,
            },
          });
          if (!section) {
            throw Error(SECTIONS_ERROR_NOT_FOUND);
          }
          studentSection.section = section;
          await entityManager.save(StudentSection, studentSection);

          const studentCourse = new StudentCourse();
          studentCourse.student = student;
          const course = await entityManager.findOne(Courses, {
            where: {
              courseId: dto.courseId,
              active: true,
            },
          });
          if (!course) {
            throw Error(COURSES_ERROR_NOT_FOUND);
          }
          studentCourse.course = course;
          await entityManager.save(StudentCourse, studentCourse);

          student = await entityManager.findOne(Students, {
            where: {
              studentCode: student.studentCode,
              active: true,
            },
            relations: {
              parentStudents: {
                parent: true,
              },
              studentCourse: {
                course: true,
              },
              department: true,
              registeredByUser: true,
              updatedByUser: true,
              school: true,
              schoolYearLevel: true,
              studentSection: {
                section: true,
              },
            },
          });
          delete student.registeredByUser.password;
          return student;
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

  // async updateProfile(studentCode, dto: UpdateStudentUserProfileDto) {
  //   return await this.studentRepo.manager.transaction(async (entityManager) => {
  //     let student = await entityManager.findOne(Students, {
  //       where: {
  //         studentCode,
  //         active: true,
  //       },
  //       relations: {
  //         parentStudents: {
  //           parent: true,
  //         },
  //         studentCourse: {
  //           course: true,
  //         },
  //         department: true,
  //         registeredByUser: true,
  //         updatedByUser: true,
  //         school: true,
  //         schoolYearLevel: true,
  //         studentSection: {
  //           section: true,
  //         },
  //       },
  //     });

  //     if (!student) {
  //       throw Error(STUDENTS_ERROR_NOT_FOUND);
  //     }

  //     student.firstName = dto.firstName;
  //     student.middleName = dto.middleName;
  //     student.lastName = dto.lastName;
  //     student.fullName = `${dto.firstName} ${dto.lastName}`;
  //     student.email = dto.email;
  //     student.mobileNumber = dto.mobileNumber;
  //     student.birthDate = moment(dto.birthDate).format("YYYY-MM-DD");
  //     student.lrn = dto.lrn;
  //     student.cardNumber = dto.cardNumber;
  //     student.gender = dto.gender;
  //     student.address = dto.address;
  //     const timestamp = await entityManager
  //       .query(CONST_QUERYCURRENT_TIMESTAMP)
  //       .then((res) => {
  //         return res[0]["timestamp"];
  //       });
  //     student.updatedDate = timestamp;
  //     student.updatedByUser = student.user;

  //     const department = await entityManager.findOne(Departments, {
  //       where: {
  //         departmentId: dto.departmentId,
  //         active: true,
  //       },
  //     });
  //     if (!department) {
  //       throw Error(DEPARTMENTS_ERROR_NOT_FOUND);
  //     }
  //     student.department = department;

  //     const schoolYearLevel = await entityManager.findOne(SchoolYearLevels, {
  //       where: {
  //         schoolYearLevelId: dto.schoolYearLevelId,
  //         school: {
  //           schoolId: student.school.schoolId,
  //         },
  //         active: true,
  //       },
  //     });
  //     if (!schoolYearLevel) {
  //       throw Error(SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND);
  //     }
  //     student.schoolYearLevel = schoolYearLevel;

  //     student = await entityManager.save(Students, student);

  //     let studentCourse = await entityManager.findOne(StudentCourse, {
  //       where: {
  //         student: {
  //           studentId: student.studentId,
  //         },
  //       },
  //     });
  //     if (!studentCourse) {
  //       studentCourse = new StudentCourse();
  //       studentCourse.student = student;
  //     }
  //     const course = await entityManager.findOne(Courses, {
  //       where: {
  //         courseId: dto.courseId,
  //         active: true,
  //       },
  //     });
  //     if (!course) {
  //       throw Error(COURSES_ERROR_NOT_FOUND);
  //     }
  //     studentCourse.course = course;
  //     await entityManager.save(StudentCourse, studentCourse);

  //     let studentSection = await entityManager.findOne(StudentSection, {
  //       where: {
  //         student: {
  //           studentId: student.studentId,
  //         },
  //       },
  //     });
  //     if (!studentSection) {
  //       studentSection = new StudentSection();
  //       studentSection.student = student;
  //     }
  //     const section = await entityManager.findOne(Sections, {
  //       where: {
  //         sectionId: dto.sectionId,
  //         active: true,
  //       },
  //     });
  //     if (!section) {
  //       throw Error(SECTIONS_ERROR_NOT_FOUND);
  //     }
  //     studentSection.section = section;
  //     await entityManager.save(StudentSection, studentSection);

  //     student = await entityManager.findOne(Students, {
  //       where: {
  //         studentCode,
  //         active: true,
  //       },
  //       relations: {
  //         parentStudents: {
  //           parent: true,
  //         },
  //         studentCourse: {
  //           course: true,
  //         },
  //         department: true,
  //         registeredByUser: true,
  //         updatedByUser: true,
  //         school: true,
  //         schoolYearLevel: true,
  //         user: true,
  //         studentSection: {
  //           section: true,
  //         },
  //       },
  //     });
  //     delete student.user.password;
  //     delete student.registeredByUser.password;
  //     if (student?.updatedByUser?.password) {
  //       delete student.updatedByUser.password;
  //     }
  //     return student;
  //   });
  // }

  async update(studentCode, dto: UpdateStudentDto) {
    return await this.studentRepo.manager.transaction(async (entityManager) => {
      let student = await entityManager.findOne(Students, {
        where: {
          studentCode,
          active: true,
        },
        relations: {
          parentStudents: {
            parent: true,
          },
          studentCourse: {
            course: true,
          },
          department: true,
          registeredByUser: true,
          updatedByUser: true,
          school: true,
          schoolYearLevel: true,
          studentSection: {
            section: true,
          },
        },
      });

      if (!student) {
        throw Error(STUDENTS_ERROR_NOT_FOUND);
      }

      student.firstName = dto.firstName;
      student.middleName = dto.middleName;
      student.lastName = dto.lastName;
      student.fullName = `${dto.firstName} ${dto.lastName}`;
      student.email = dto.email;
      student.mobileNumber = dto.mobileNumber;
      student.birthDate = moment(dto.birthDate).format("YYYY-MM-DD");
      student.lrn = dto.lrn;
      student.cardNumber = dto.cardNumber;
      student.gender = dto.gender;
      student.address = dto.address;
      const timestamp = await entityManager
        .query(CONST_QUERYCURRENT_TIMESTAMP)
        .then((res) => {
          return res[0]["timestamp"];
        });
      student.updatedDate = timestamp;

      const updatedByUser = await entityManager.findOne(Users, {
        where: {
          userId: dto.updatedByUserId,
          active: true,
        },
      });
      if (!updatedByUser) {
        throw Error(USER_ERROR_USER_NOT_FOUND);
      }
      student.updatedByUser = updatedByUser;

      const department = await entityManager.findOne(Departments, {
        where: {
          departmentId: dto.departmentId,
          active: true,
        },
      });
      if (!department) {
        throw Error(DEPARTMENTS_ERROR_NOT_FOUND);
      }
      student.department = department;

      const schoolYearLevel = await entityManager.findOne(SchoolYearLevels, {
        where: {
          schoolYearLevelId: dto.schoolYearLevelId,
          school: {
            schoolId: student.school.schoolId,
          },
          active: true,
        },
      });
      if (!schoolYearLevel) {
        throw Error(SCHOOL_YEAR_LEVELS_ERROR_NOT_FOUND);
      }
      student.schoolYearLevel = schoolYearLevel;

      student = await entityManager.save(Students, student);

      let studentSection = await entityManager.findOne(StudentSection, {
        where: {
          student: {
            studentId: student.studentId,
          },
        },
      });
      if (studentSection) {
        await entityManager.delete(StudentSection, studentSection);
      } else {
        studentSection = new StudentSection();
      }
      const section = await entityManager.findOne(Sections, {
        where: {
          sectionId: dto.sectionId,
          active: true,
        },
      });
      if (!section) {
        throw Error(SECTIONS_ERROR_NOT_FOUND);
      }
      studentSection.section = section;
      await entityManager.save(StudentSection, studentSection);

      let studentCourse = await entityManager.findOne(StudentCourse, {
        where: {
          student: {
            studentId: student.studentId,
          },
        },
      });
      if (studentCourse) {
        await entityManager.delete(StudentCourse, studentCourse);
      } else {
        studentCourse = new StudentCourse();
      }
      studentCourse.student = student;
      const course = await entityManager.findOne(Courses, {
        where: {
          courseId: dto.courseId,
          active: true,
        },
      });
      if (!course) {
        throw Error(COURSES_ERROR_NOT_FOUND);
      }
      studentCourse.course = course;
      await entityManager.save(StudentCourse, studentCourse);

      student = await entityManager.findOne(Students, {
        where: {
          studentCode,
          active: true,
        },
        relations: {
          parentStudents: {
            parent: true,
          },
          studentCourse: {
            course: true,
          },
          department: true,
          registeredByUser: true,
          updatedByUser: true,
          school: true,
          schoolYearLevel: true,
          studentSection: {
            section: true,
          },
        },
      });

      delete student.registeredByUser.password;
      if (student?.updatedByUser?.password) {
        delete student.updatedByUser.password;
      }
      return student;
    });
  }

  // async resetPassword(studentCode, dto: UpdateUserResetPasswordDto) {
  //   return await this.studentRepo.manager.transaction(async (entityManager) => {
  //     let student = await entityManager.findOne(Students, {
  //       where: {
  //         studentCode,
  //         active: true,
  //       },
  //       relations: {
  //         user: true,
  //       },
  //     });

  //     if (!student) {
  //       throw Error(STUDENTS_ERROR_NOT_FOUND);
  //     }

  //     const user = student.user;
  //     user.password = await hash(dto.password);
  //     await entityManager.save(Users, user);
  //     student = await entityManager.findOne(Students, {
  //       where: {
  //         studentCode,
  //         active: true,
  //       },
  //       relations: {
  //         parentStudents: {
  //           parent: true,
  //         },
  //         studentCourse: {
  //           course: true,
  //         },
  //         department: true,
  //         registeredByUser: true,
  //         updatedByUser: true,
  //         school: true,
  //         schoolYearLevel: true,
  //         user: true,
  //         studentSection: {
  //           section: true,
  //         },
  //       },
  //     });
  //     delete student.user.password;
  //     delete student.registeredByUser.password;
  //     if (student?.updatedByUser?.password) {
  //       delete student.updatedByUser.password;
  //     }
  //     return student;
  //   });
  // }

  async delete(studentCode) {
    return await this.studentRepo.manager.transaction(async (entityManager) => {
      let student = await entityManager.findOne(Students, {
        where: {
          studentCode,
          active: true,
        },
        relations: {},
      });

      if (!student) {
        throw Error(STUDENTS_ERROR_NOT_FOUND);
      }

      student.active = false;
      await entityManager.save(Students, student);
      // const user = student.user;
      // user.active = false;
      // await entityManager.save(Users, user);
      student = await entityManager.findOne(Students, {
        where: {
          studentCode,
        },
        relations: {
          parentStudents: {
            parent: true,
          },
          studentCourse: {
            course: true,
          },
          department: true,
          registeredByUser: true,
          updatedByUser: true,
          school: true,
          schoolYearLevel: true,
          studentSection: {
            section: true,
          },
        },
      });
      delete student.registeredByUser.password;
      if (student?.updatedByUser?.password) {
        delete student.updatedByUser.password;
      }
      return student;
    });
  }

  async approveAccessRequest(studentCode) {
    return await this.studentRepo.manager.transaction(async (entityManager) => {
      let student = await entityManager.findOne(Students, {
        where: {
          studentCode,
          active: true,
        },
        relations: {},
      });

      if (!student) {
        throw Error(STUDENTS_ERROR_NOT_FOUND);
      }

      student.accessGranted = true;
      await entityManager.save(Students, student);
      student = await entityManager.findOne(Students, {
        where: {
          studentCode,
        },
        relations: {
          parentStudents: {
            parent: true,
          },
          studentCourse: {
            course: true,
          },
          department: true,
          registeredByUser: true,
          updatedByUser: true,
          school: true,
          schoolYearLevel: true,
          studentSection: {
            section: true,
          },
        },
      });
      delete student.registeredByUser.password;
      if (student?.updatedByUser?.password) {
        delete student.updatedByUser.password;
      }
      return student;
    });
  }
}
