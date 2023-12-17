import { Component } from '@angular/core';
import { Employees } from 'src/app/model/Employees';
import { Operators } from 'src/app/model/Operators';
import { Users } from 'src/app/model/users';
import { StorageService } from 'src/app/services/storage.service';

@Component({
  selector: 'app-org-home',
  templateUrl: './org-home.component.html',
  styleUrls: ['./org-home.component.scss']
})
export class OrgHomeComponent {
  profile: Operators | Employees;
  constructor(private storageService: StorageService) {
    this.profile = this.storageService.getLoginProfile();
  }
}
