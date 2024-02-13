import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FunkoDetailComponent } from './funko-detail.component';

describe('FunkoDetailComponent', () => {
  let component: FunkoDetailComponent;
  let fixture: ComponentFixture<FunkoDetailComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [FunkoDetailComponent]
    });
    fixture = TestBed.createComponent(FunkoDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
