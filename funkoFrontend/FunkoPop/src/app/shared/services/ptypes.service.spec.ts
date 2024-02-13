import { TestBed } from '@angular/core/testing';

import { PtypesService } from './ptypes.service';

describe('PtypesService', () => {
  let service: PtypesService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PtypesService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
