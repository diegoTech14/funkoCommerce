import { Injectable } from '@angular/core';
import { FunkoModel } from '../models/funko.models';
import { Observable, throwError } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CartService {
  SERVICE : string = 'http://funkobackend';
  constructor() { }

  
addingFunkoToCart() : void{
  let quantityCart = document.getElementById('quantityCart') as HTMLSpanElement;
  let localCart = localStorage.getItem('FUNKOS');
  if(localCart){
    localCart = JSON.parse(localCart);
    let counter = 0;
    if(localCart!=null){
      for(let i = 1; i < localCart.length; i++){
        counter++;
      }
      quantityCart.innerHTML = String(counter);
    }
  }
}


}
