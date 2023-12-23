import { Component } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { SpinnerVisibilityService } from 'ng-http-loader';
import { Subscription, forkJoin } from 'rxjs';
import { Departments } from 'src/app/model/departments';
import { SchoolYearLevels } from 'src/app/model/school-year-levels';
import { Schools } from 'src/app/model/schools';
import { Students } from 'src/app/model/students';
import { StudentsService } from 'src/app/services/students.service';
import { StorageService } from 'src/app/services/storage.service';
import { AlertDialogModel } from 'src/app/shared/alert-dialog/alert-dialog-model';
import { AlertDialogComponent } from 'src/app/shared/alert-dialog/alert-dialog.component';
import { MyErrorStateMatcher } from 'src/app/shared/form-validation/error-state.matcher';
import { SelectDepartmentDialogComponent } from 'src/app/shared/select-department-dialog/select-department-dialog.component';
import { SelectEmployeeDialogComponent } from 'src/app/shared/select-employee-dialog/select-employee-dialog.component';
import { SelectSchoolYearLevelDialogComponent } from 'src/app/shared/select-school-year-level-dialog/select-school-year-level-dialog.component';
import { Courses } from 'src/app/model/courses';
import { Sections } from 'src/app/model/sections';
import { SelectCourseDialogComponent } from 'src/app/shared/select-course-dialog/select-course-dialog.component';
import { SelectSectionDialogComponent } from 'src/app/shared/select-section-dialog/select-section-dialog.component';

@Component({
  selector: 'app-ops-students-form',
  templateUrl: './ops-students-form.component.html',
  styleUrls: ['./ops-students-form.component.scss']
})
export class OpsStudentFormComponent {
  title;
  studentCode;
  isNew = false;
  error;
  isLoading = true;
  studentForm: FormGroup;
  mediaWatcher: Subscription;
  matcher = new MyErrorStateMatcher();
  isProcessing = false;
  student: Students;
  school: Schools;
  schoolYearLevel: SchoolYearLevels;
  department: Departments;
  section: Sections;
  course: Courses;
  currentOperatorCode;

  constructor(
    private formBuilder: FormBuilder,
    private studentsService: StudentsService,
    private storageService: StorageService,
    private snackBar: MatSnackBar,
    private dialog: MatDialog,
    private spinner: SpinnerVisibilityService,
    public dialogRef: MatDialogRef<OpsStudentFormComponent>) {
      this.studentForm = this.formBuilder.group(
        {
          orgStudentId: new FormControl(null, Validators.required),
          firstName: new FormControl(null, Validators.required),
          middleInitial: new FormControl(null),
          lastName: new FormControl(null, Validators.required),
          mobileNumber: new FormControl(null, Validators.required),
          lrn: new FormControl(null),
          cardNumber: new FormControl(null, Validators.required),
          birthDate: new FormControl(null),
          gender: new FormControl(null, Validators.required),
          address: new FormControl(null),
          courseId: new FormControl(null, Validators.required),
          sectionId: new FormControl(null, Validators.required),
          departmentId: new FormControl(null, Validators.required),
          schoolYearLevelId: new FormControl(null, Validators.required)
        }
      );
  }
  get f() {
    return this.studentForm.controls;
  }
  get formIsValid() {
    return this.studentForm.valid;
  }
  get formIsReady() {
    return this.studentForm.valid && this.studentForm.dirty;
  }
  get formData() {
    return this.studentForm.value;
  }

  async initDetails() {
    try {
      forkJoin([
        this.studentsService.getByCode(this.studentCode).toPromise()
      ]).subscribe(([student])=> {
        if (student.success) {
          this.student = student.data;
          this.studentForm.patchValue({
            orgStudentId: student.data.orgStudentId,
            firstName: student.data.firstName,
            middleInitial: student.data.middleInitial,
            lastName: student.data.lastName,
            mobileNumber: student.data.mobileNumber,
            lrn: student.data.lrn,
            cardNumber: student.data.cardNumber,
            birthDate: student.data.birthDate,
            gender: student.data.gender,
            address: student.data.address,
            courseId: student.data.studentCourse?.course?.courseId,
            sectionId: student.data.studentSection?.section?.sectionId,
            departmentId: student.data.department?.departmentId,
            schoolYearLevelId: student.data.schoolYearLevel?.schoolYearLevelId
          });
          this.course = student.data?.studentCourse?.course;
          this.section = student.data?.studentSection?.section;
          this.department = student.data?.department;
          this.schoolYearLevel = student.data?.schoolYearLevel;
          this.studentForm.updateValueAndValidity();
          this.isLoading = false;
        } else {
          this.isLoading = false;
          this.error = Array.isArray(student.message) ? student.message[0] : student.message;
          this.snackBar.open(this.error, 'close', {
            panelClass: ['style-error'],
          });
        }
      });
    } catch(ex) {
      this.isLoading = false;
      this.error = Array.isArray(ex.message) ? ex.message[0] : ex.message;
      this.snackBar.open(this.error, 'close', {
        panelClass: ['style-error'],
      });
    }
  }

  getError(key: string) {
    return this.f[key].errors;
  }
  onSubmit() {
    if (this.studentForm.invalid) {
      return;
    }

    const dialogData = new AlertDialogModel();
    dialogData.title = 'Confirm';
    dialogData.message = this.isNew ? 'Save student' : 'Update student?';
    dialogData.confirmButton = {
      visible: true,
      text: 'yes',
      color: 'primary',
    };
    dialogData.dismissButton = {
      visible: true,
      text: 'cancel',
    };
    const dialogRef = this.dialog.open(AlertDialogComponent, {
      maxWidth: '400px',
      closeOnNavigation: true,
    });
    dialogRef.componentInstance.alertDialogConfig = dialogData;

    dialogRef.componentInstance.conFirm.subscribe(async (data: any) => {
      this.isProcessing = true;
      dialogRef.componentInstance.isProcessing = this.isProcessing;
      try {
        this.isProcessing = true;
        let params = this.formData;
        let res;
        if(this.isNew) {
          params = {
            ...params,
            schoolId: this.school?.schoolId,
            registeredByUserId: this.currentOperatorCode
          }
          res = await this.studentsService.create(params).toPromise();
        } else {
          params = {
            ...params,
            updatedByUserId: this.currentOperatorCode
          }
          res = await this.studentsService.update(this.studentCode, params).toPromise();
        }

        if (res.success) {
          this.snackBar.open('Saved!', 'close', {
            panelClass: ['style-success'],
          });
          this.isProcessing = false;
          dialogRef.componentInstance.isProcessing = this.isProcessing;
          dialogRef.close();
          this.dialogRef.close(true);
        } else {
          this.isProcessing = false;
          dialogRef.componentInstance.isProcessing = this.isProcessing;
          this.error = Array.isArray(res.message)
            ? res.message[0]
            : res.message;
          this.snackBar.open(this.error, 'close', {
            panelClass: ['style-error'],
          });
          dialogRef.close();
        }
      } catch (e) {
        this.isProcessing = false;
        dialogRef.componentInstance.isProcessing = this.isProcessing;
        this.error = Array.isArray(e.message) ? e.message[0] : e.message;
        this.snackBar.open(this.error, 'close', {
          panelClass: ['style-error'],
        });
        dialogRef.close();
      }
    });
  }

  showSelectSchoolYearLevelDialog() {
    const dialogRef = this.dialog.open(SelectSchoolYearLevelDialogComponent, {
        disableClose: true,
        panelClass: "select-school-year-level-dialog"
    });
    dialogRef.componentInstance.selected = {
      schoolYearLevelCode: this.schoolYearLevel?.schoolYearLevelCode,
      name: this.schoolYearLevel?.name,
      selected: true
    }
    dialogRef.componentInstance.schoolCode = this.school?.schoolCode;
    dialogRef.afterClosed().subscribe((res:SchoolYearLevels)=> {
      console.log(res);
      if(res) {
        this.schoolYearLevel = res;
        this.f["schoolYearLevelId"].setValue(res.schoolYearLevelId);
      }
      this.f["schoolYearLevelId"].markAllAsTouched();
      this.f["schoolYearLevelId"].markAsDirty();
    })
  }

  showSelectDepartmentDialog() {
    const dialogRef = this.dialog.open(SelectDepartmentDialogComponent, {
        disableClose: true,
        panelClass: "select-department-dialog"
    });
    dialogRef.componentInstance.selected = {
      departmentCode: this.department?.departmentCode,
      departmentName: this.department?.departmentName,
      selected: true
    }
    dialogRef.componentInstance.schoolCode = this.school?.schoolCode;
    dialogRef.afterClosed().subscribe((res:Departments)=> {
      console.log(res);
      if(res) {
        this.department = res;
        this.f["departmentId"].setValue(res.departmentId);
      }
      this.f["departmentId"].markAllAsTouched();
      this.f["departmentId"].markAsDirty();
    })
  }

  showSelectCourseDialog() {
    const dialogRef = this.dialog.open(SelectCourseDialogComponent, {
        disableClose: true,
        panelClass: "select-course-dialog"
    });
    dialogRef.componentInstance.selected = {
      courseCode: this.course?.courseCode,
      name: this.course?.name,
      selected: true
    }
    dialogRef.componentInstance.schoolCode = this.school?.schoolCode;
    dialogRef.afterClosed().subscribe((res:Courses)=> {
      console.log(res);
      if(res) {
        this.course = res;
        this.f["courseId"].setValue(res.courseId);
      }
      this.f["courseId"].markAllAsTouched();
      this.f["courseId"].markAsDirty();
    })
  }

  showSelectSectionDialog() {
    const dialogRef = this.dialog.open(SelectSectionDialogComponent, {
        disableClose: true,
        panelClass: "select-section-dialog"
    });
    dialogRef.componentInstance.selected = {
      sectionCode: this.section?.sectionCode,
      sectionName: this.section?.sectionName,
      selected: true
    }
    dialogRef.componentInstance.schoolCode = this.school?.schoolCode;
    dialogRef.afterClosed().subscribe((res:Sections)=> {
      console.log(res);
      if(res) {
        this.section = res;
        this.f["sectionId"].setValue(res.sectionId);
      }
      this.f["sectionId"].markAllAsTouched();
      this.f["sectionId"].markAsDirty();
    })
  }
}
