import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Component, inject } from '@angular/core';
import { FunkoService } from 'src/app/shared/services/funko.service';
import { CartService } from 'src/app/shared/services/cart.service';
import { SaleDetail } from 'src/app/shared/models/sale_detail';

@Component({
  selector: 'app-pay',
  templateUrl: './pay.component.html',
  styleUrls: ['./pay.component.css']
})
export class PayComponent {

  serviceFunko = inject(FunkoService);
  serviceCart = inject(CartService);
  funkos = [new SaleDetail];
  subTotal = 0;
  localStore = localStorage.getItem('FUNKOS');
  taxe = 13;
  disacount = 0;
  disacountDollar = 0;
  shippingCost = 65;

  quantityFromFeed = 3;

  constructor() {
  }
  searchInternalFunko(id: any) {
    let funkoFound;

    for(let i = 0; i < this.funkos.length;i++){
      if (this.funkos[i].id == id){
        funkoFound = this.funkos[i];
        break;
      }
    }
    return funkoFound;
  }


  onLoad() {

    var localCart = localStorage.getItem('FUNKOS');

    if (localCart) {
      localCart = JSON.parse(localCart);
      this.funkos.pop();//AÑADE UN NUEVO OBJETO PERO EN EL FEED NO LO HACE
      if (localCart != null) {
        for (let i = 1; i < localCart.length; i++) {
          let funko 
          if (typeof localCart[i] === 'string') {
              funko = JSON.parse(localCart[i]);
              this.funkos.push(funko);
              
          } else {
              funko = JSON.parse(JSON.stringify(localCart[i]));
              this.funkos.push(funko);
          }
          
        }
      }
    }
    console.log(this.funkos);
    
    this.onCalculated();
  }


  onCalculatedDelete() {
    if (this.funkos) {
      this.funkos.forEach((funko) => {
        this.subTotal -= (funko.quantity * funko.price) - this.disacount;
      })
    }
  }

  onCalculated() {
    this.disacount = this.funkos.length;
    if (this.funkos) {
      this.funkos.forEach((funko) => {
        this.subTotal += (funko.quantity * funko.price) - this.disacount;
      })
    }
    this.disacountDollar = (this.subTotal * this.disacount) / 100;
    this.subTotal += this.shippingCost;
    this.subTotal -= this.disacountDollar;
  }

  //Implement this method
  onSetQuantity(id:any) {
    let funkoFound = this.searchInternalFunko(id);
    if(funkoFound){
      this.quantityFromFeed = funkoFound.quantity;
    }
  }

  onDeleteFunko(id: any) {
    if (this.funkos) {
      this.funkos.forEach((funko) => {
        if (funko.id == id) {
          this.funkos.splice(this.funkos.indexOf(funko), 1);
          localStorage.setItem('FUNKOS', JSON.stringify(this.funkos));
          if (this.funkos.length <= 0) {

            localStorage.clear();
            location.reload();
          }
          this.onCalculatedDelete();
          return;
        }
      })
    }

  }

  ngOnInit(): void {
    this.onLoad();
  }
}