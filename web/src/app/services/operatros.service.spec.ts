import { TestBed } from '@angular/core/testing';

import { OperatorsService } from './operatros.service';

describe('OperatorsService', () => {
  let service: OperatorsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(OperatorsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
