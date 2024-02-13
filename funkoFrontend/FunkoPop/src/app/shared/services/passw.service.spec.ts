import { TestBed } from '@angular/core/testing';

import { PasswService } from './passw.service';

describe('PasswService', () => {
  let service: PasswService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PasswService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
