import { Component } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatTableDataSource } from '@angular/material/table';
import { ActivatedRoute, Router } from '@angular/router';
import { Departments } from 'src/app/model/departments';
import { Schools } from 'src/app/model/schools';
import { AppConfigService } from 'src/app/services/app-config.service';
import { DepartmentsService } from 'src/app/services/departments.service';
import { SchoolsService } from 'src/app/services/schools.service';
import { StorageService } from 'src/app/services/storage.service';
import { StudentsService } from 'src/app/services/students.service';
import { AlertDialogModel } from 'src/app/shared/alert-dialog/alert-dialog-model';
import { AlertDialogComponent } from 'src/app/shared/alert-dialog/alert-dialog.component';
import { SelectDepartmentDialogComponent } from 'src/app/shared/select-department-dialog/select-department-dialog.component';
import { SelectSchoolDialogComponent } from 'src/app/shared/select-school-dialog/select-school-dialog.component';
import { OpsStudentsTableColumn } from 'src/app/shared/utility/table';
import { convertNotationToObject } from 'src/app/shared/utility/utility';
import { Location } from '@angular/common';
import { SelectSchoolYearLevelDialogComponent } from 'src/app/shared/select-school-year-level-dialog/select-school-year-level-dialog.component';
import { SchoolYearLevels } from 'src/app/model/school-year-levels';
import { SchoolYearLevelsService } from 'src/app/services/school-year-levels.service';
import { OpsStudentFormComponent } from './ops-students-form/ops-students-form.component';
import { OpsStudentParentsDialogComponent } from './ops-students-parents-dialog/ops-students-parents-dialog.component';
@Component({
  selector: 'app-ops-students',
  templateUrl: './ops-students.component.html',
  styleUrls: ['./ops-students.component.scss'],
  host: {
    class: "page-component"
  }
})
export class OpsStudentsComponent  {
  currentOperatorCode:string;
  error:string;
  dataSource = new MatTableDataSource<OpsStudentsTableColumn>();
  columnDefs = [];
  displayedColumns = [];
  isLoading = false;
  isProcessing = false;
  pageIndex = 0;
  pageSize = 10;
  total = 0;
  order: any = { studentCode: "DESC" };

  filter: {
    apiNotation: string;
    filter: any;
    name?: string;
    type: string;
  }[] = [];

  requestingAccess = 0;
  selectedSchool: Schools;
  selectedSchoolYearLevel: SchoolYearLevels;

  constructor(
    private _location: Location,
    private studentsService: StudentsService,
    private schoolsService: SchoolsService,
    private schoolYearLevelsService: SchoolYearLevelsService,
    private snackBar: MatSnackBar,
    private dialog: MatDialog,
    public appConfig: AppConfigService,
    private storageService: StorageService,
    private route: ActivatedRoute,
    public router: Router) {
      this.dataSource = new MatTableDataSource([]);
      if(this.route.snapshot.data) {
      }
      this.selectedSchool = new Schools();
      this.selectedSchoolYearLevel = new SchoolYearLevels();
      this.selectedSchool.schoolCode = this.route.snapshot.paramMap.get('schoolCode');
      if(!this.selectedSchool?.schoolCode || this.selectedSchool?.schoolCode === '') {
        this.selectedSchool.schoolCode = this.storageService.getOpsRecentSchool();
      }
      this.selectedSchoolYearLevel.schoolYearLevelCode = this.route.snapshot.paramMap.get('schoolYearLevelCode');
      if(this.selectedSchool?.schoolCode && this.selectedSchool?.schoolCode !== "" && (!this.selectedSchoolYearLevel?.schoolYearLevelCode || this.selectedSchoolYearLevel?.schoolYearLevelCode === '')) {
        this.router.navigate(["/ops/students/find/" +this.selectedSchool?.schoolCode]);
      }
      this.appConfig.config.tableColumns.students.forEach(x=> {
        if(x.name === "menu") {
          const menu = [{
            "name": "parents",
            "label": "Parents"
          },{
            "name": "edit",
            "label": "Edit"
          },{
            "name": "delete",
            "label": "Delete"
          }];
          x["controlsMenu"] = menu;
        }
        this.columnDefs.push(x)
      });
    }

  ngOnInit(): void {
    const profile = this.storageService.getLoginProfile();
    this.currentOperatorCode = profile["operatorCode"];
  }

  async ngAfterViewInit() {
    const currentSelectedSchool = this.selectedSchool?.schoolCode ? this.selectedSchool?.schoolCode : "";
    const currentSelectedDepartment = this.selectedSchoolYearLevel?.schoolYearLevelCode ? this.selectedSchoolYearLevel?.schoolYearLevelCode : "";
    Promise.all([
      currentSelectedSchool && currentSelectedSchool !== "" ? this.schoolsService.getByCode(currentSelectedSchool).toPromise() : null,
      currentSelectedDepartment && currentSelectedDepartment !== "" ? this.schoolYearLevelsService.getByCode(currentSelectedDepartment).toPromise() : null,
      this.getStudentsPaginated(),
    ]).then(([school, schoolYearLevel, student])=> {
      if(school?.success && school?.data && school.data?.schoolName) {
        this.selectedSchool = school.data;
      }
      if(schoolYearLevel?.success && schoolYearLevel?.data && schoolYearLevel.data?.schoolYearLevelCode) {
        this.selectedSchoolYearLevel = schoolYearLevel.data;
      }
    });



  }

  filterChange(event: {
    apiNotation: string;
    filter: string;
    name: string;
    type: string;
  }[]) {
    this.filter = event;
    this.getStudentsPaginated();
  }

  async pageChange(event: { pageIndex: number, pageSize: number }) {
    this.pageIndex = event.pageIndex;
    this.pageSize = event.pageSize;
    await this.getStudentsPaginated();
  }

  async sortChange(event: { active: string, direction: string }) {
    const { active, direction } = event;
    const { apiNotation } = this.appConfig.config.tableColumns.students.find(x=>x.name === active);
    this.order = convertNotationToObject(apiNotation, direction.toUpperCase());
    this.getStudentsPaginated()
  }

  showSelectSchoolDialog() {
    const dialogRef = this.dialog.open(SelectSchoolDialogComponent, {
        disableClose: true,
        panelClass: "select-item-dialog"
    });
    dialogRef.componentInstance.selected = {
      schoolCode: this.selectedSchool?.schoolCode,
      schoolName: this.selectedSchool?.schoolName,
      selected: true
    }
    dialogRef.afterClosed().subscribe((res:Schools)=> {
      console.log(res);
      if(res) {
        this.selectedSchool = res;
        this.storageService.saveOpsRecentSchool(res.schoolCode);
        this._location.go("/ops/students/find/" + res?.schoolCode);
        this.getStudentsPaginated();
      }
    })
  }

  showSelectSchoolYearLevelDialog() {
    const dialogRef = this.dialog.open(SelectSchoolYearLevelDialogComponent, {
        disableClose: true,
        panelClass: "select-school-year-level-dialog"
    });
    dialogRef.componentInstance.selected = {
      schoolYearLevelCode: this.selectedSchoolYearLevel?.schoolYearLevelCode,
      name: this.selectedSchoolYearLevel?.name,
      selected: true
    }
    dialogRef.componentInstance.schoolCode = this.selectedSchool?.schoolCode;
    dialogRef.afterClosed().subscribe((res:SchoolYearLevels)=> {
      console.log(res);
      if(res) {
        this.selectedSchoolYearLevel = res;
        this._location.go("/ops/students/find/" + this.selectedSchool?.schoolCode + "/sylvl/" + this.selectedSchoolYearLevel?.schoolYearLevelCode);
        this.getStudentsPaginated();
      }
    })
  }

  getStudentsPaginated(){
    try{
      if(!this.selectedSchool?.schoolCode || this.selectedSchool?.schoolCode === "") {
        return;
      }
      let findIndex = this.filter.findIndex(x=>x.apiNotation === "school.schoolCode");
      if(findIndex >= 0) {
        this.filter[findIndex] = {
          apiNotation: "school.schoolCode",
          filter: this.selectedSchool?.schoolCode,
          type: "precise"
        };
      } else {
        this.filter.push({
          apiNotation: "school.schoolCode",
          filter: this.selectedSchool?.schoolCode,
          type: "precise"
        });
      }
      findIndex = this.filter.findIndex(x=>x.apiNotation === "schoolYearLevel.schoolYearLevelCode");
      if(findIndex >= 0) {
        this.filter[findIndex] = {
          apiNotation: "schoolYearLevel.schoolYearLevelCode",
          filter: this.selectedSchoolYearLevel?.schoolYearLevelCode,
          type: "precise"
        };
      } else {
        this.filter.push({
          apiNotation: "schoolYearLevel.schoolYearLevelCode",
          filter: this.selectedSchoolYearLevel?.schoolYearLevelCode,
          type: "precise"
        });
      }
      this.isLoading = true;
      this.studentsService.getByAdvanceSearch({
        order: this.order,
        columnDef: this.filter,
        pageIndex: this.pageIndex, pageSize: this.pageSize
      })
      .subscribe(async res => {
        if(res.success){
          let data = res.data.results.map((d)=>{
            return {
              studentCode: d.studentCode,
              fullName: d.fullName,
              lrn: d.lrn,
              cardNumber: d.cardNumber,
              mobileNumber: d.mobileNumber,
              schoolYearLevel: d.schoolYearLevel.name,
              studentCourse: d.studentCourse.course.name,
              studentSection: d.studentSection.section.sectionName,
              department: d.department.departmentName,
            } as OpsStudentsTableColumn
          });
          this.total = res.data.total;
          this.requestingAccess = res.data.requestingAccess;
          this.dataSource = new MatTableDataSource(data);
          this.isLoading = false;
        }
        else{
          this.error = Array.isArray(res.message) ? res.message[0] : res.message;
          this.snackBar.open(this.error, 'close', {panelClass: ['style-error']});
          this.isLoading = false;
        }
      }, async (err) => {
        this.error = Array.isArray(err.message) ? err.message[0] : err.message;
        this.snackBar.open(this.error, 'close', {panelClass: ['style-error']});
        this.isLoading = false;
      });
    }
    catch(e){
      this.error = Array.isArray(e.message) ? e.message[0] : e.message;
      this.snackBar.open(this.error, 'close', {panelClass: ['style-error']});
    }

  }

  controlMenuItemSelected(type: "parents" | "edit" | "delete", data: OpsStudentsTableColumn) {
    console.log(type, data);
    if(type === "parents") {
      const dialogRef = this.dialog.open(OpsStudentParentsDialogComponent, {
        maxWidth: '720px',
        width: '720px',
        disableClose: true,
        panelClass: "form-dialog"
      });
      dialogRef.componentInstance.studentCode = data.studentCode;
      dialogRef.componentInstance.init();
    }
    else if(type === "edit") {
      const dialogRef = this.dialog.open(OpsStudentFormComponent, {
        maxWidth: '720px',
        width: '720px',
        disableClose: true,
        panelClass: "form-dialog"
      });
      dialogRef.componentInstance.title = "Update Student";
      dialogRef.componentInstance.school = this.selectedSchool;
      dialogRef.componentInstance.studentCode = data.studentCode;
      dialogRef.componentInstance.schoolYearLevel = this.selectedSchoolYearLevel && this.selectedSchoolYearLevel?.schoolYearLevelCode ? this.selectedSchoolYearLevel : null;
      dialogRef.componentInstance.currentOperatorCode = this.currentOperatorCode;
      dialogRef.componentInstance.initDetails();
      dialogRef.afterClosed().subscribe(res=> {
        if(res) {
          this.getStudentsPaginated();
        }
      });
    } else if(type === "delete") {
      this.onDelete(data.studentCode);
    }
  }

  newStudentDialog() {
    const dialogRef = this.dialog.open(OpsStudentFormComponent, {
      maxWidth: '720px',
      width: '720px',
      disableClose: true,
      panelClass: "form-dialog"
    });
    dialogRef.componentInstance.title = "New Student";
    dialogRef.componentInstance.isNew = true;
    dialogRef.componentInstance.school = this.selectedSchool;
    dialogRef.componentInstance.schoolYearLevel = this.selectedSchoolYearLevel && this.selectedSchoolYearLevel?.schoolYearLevelCode ? this.selectedSchoolYearLevel : null;
    dialogRef.componentInstance.currentOperatorCode = this.currentOperatorCode;
    dialogRef.afterOpened().subscribe(()=> {
      if(this.selectedSchoolYearLevel?.schoolYearLevelId && this.selectedSchoolYearLevel?.schoolYearLevelId !== "") {
        dialogRef.componentInstance.f["schoolYearLevelId"].setValue(this.selectedSchoolYearLevel.schoolYearLevelId);
        dialogRef.componentInstance.f["schoolYearLevelId"].markAllAsTouched();
        dialogRef.componentInstance.f["schoolYearLevelId"].markAsDirty();
      }
    });
    dialogRef.afterClosed().subscribe(res=> {
      if(res) {
        this.getStudentsPaginated();
      }
    });
  }

  onDelete(studentCode: string) {
    const dialogData = new AlertDialogModel();
    dialogData.title = 'Confirm';
    dialogData.message = 'Delete student?';
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
        let res = await this.studentsService.delete(studentCode).toPromise();
        if (res.success) {
          this.snackBar.open('Student deleted!', 'close', {
            panelClass: ['style-success'],
          });
          this.isProcessing = false;
          dialogRef.componentInstance.isProcessing = this.isProcessing;
          dialogRef.close();
          this.getStudentsPaginated();
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

}