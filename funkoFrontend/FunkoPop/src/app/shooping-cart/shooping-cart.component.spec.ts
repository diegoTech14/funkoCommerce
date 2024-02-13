import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ShoopingCartComponent } from './shooping-cart.component';

describe('ShoopingCartComponent', () => {
  let component: ShoopingCartComponent;
  let fixture: ComponentFixture<ShoopingCartComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ShoopingCartComponent]
    });
    fixture = TestBed.createComponent(ShoopingCartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
