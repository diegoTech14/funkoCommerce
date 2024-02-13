import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FunkoCrudComponent } from './funko-crud.component';

describe('FunkoCrudComponent', () => {
  let component: FunkoCrudComponent;
  let fixture: ComponentFixture<FunkoCrudComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [FunkoCrudComponent]
    });
    fixture = TestBed.createComponent(FunkoCrudComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
