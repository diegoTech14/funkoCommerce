
import { Component, OnInit, inject } from '@angular/core';
import { FunkoService } from '../../shared/services/funko.service';
import { Router } from '@angular/router';
import { FunkoModel } from 'src/app/shared/models/funko.models';
import { SaleDetail } from 'src/app/shared/models/sale_detail';
import { CartService } from 'src/app/shared/services/cart.service';
@Component({
  selector: 'app-feed',
  templateUrl: './feed.component.html',
  styleUrls: ['./feed.component.css']
})

export class FeedComponent implements OnInit {

  filter: any;

  //Injections
  serviceFunko = inject(FunkoService);
  serviceCart = inject(CartService);


  router = inject(Router);
  funkos = [new FunkoModel];
  quantity = 1;
  cart = [new SaleDetail]; // object array
  FUNKOSCART = "FUNKOS";

  //Attributes to use in HTML
  funkoPrice = 0;
  funkoName = "";
  funkoDescription = "";
  funkoTypeName = "";
  funkoCategoryName = "";

  currentID = "";

  pages = [2, 5, 10, 20, 50];
  currentPage = 1;
  itemsPerPage = 8;
  numberOfRegs = 0;


  resetFilter() {
    this.filter = { id: '', name: '', productTypeID: '', categoryID: '', exclusivity: '' };
    this.onFeed();
  }


  onChangePage(e: any) {
    this.currentPage = e;
    this.onFeed();
   
  }
  onChangeTama(e: any) {
    this.itemsPerPage = parseInt(e.target.value);
    this.currentPage = 1;
    this.onFeed();
  
  }

  onRedirectCart(){
    this.router.navigate(['/cart']);
  }

  onSearch(id: any) {
    this.serviceFunko.search(id)
      .subscribe(
        data => {
          console.log(data);
        }
      )
  }

  setSuggestedFunkosImages(idElement: number, urlImage: string) {
    let funkoElementsImages = [
      'firstRecommendation',
      'secondRecommendation',
      'thirdRecommendation'
    ];
    let suggestedFunkoElement = document.getElementById(funkoElementsImages[idElement]);
    suggestedFunkoElement?.setAttribute('src', urlImage);

  }

  suggestedFunkos(id: any) {

    this.serviceFunko.filterCategorySuggested(id)
      .subscribe(
        data => {

          let numbers = [-1];
          let counter = -1;
          let dataLength = data.length;

          while (true) {
            if (numbers.length == 4) {
              break;
            }
            let aleatoryNumber = Math.floor(Math.random() * dataLength);
            if (!numbers.slice(1, dataLength).includes(aleatoryNumber)) {
              counter++;
              numbers.push(aleatoryNumber);
              this.setSuggestedFunkosImages(counter, data[aleatoryNumber].urlSecondImage);
            }

          }
          console.log(numbers);
        }

      )
  }


  storeInLocal(paramCart: any) {
    localStorage.setItem(this.FUNKOSCART, JSON.stringify(paramCart));
  }


  onDetail(id: any) {
    console.log(id);
    this.serviceFunko.search(id)
      .subscribe(
        data => {
          this.funkoName = data.name;
          this.funkoPrice = data.price;
          this.funkoDescription = data.description;
          this.funkoTypeName = data.typeName;
          this.funkoCategoryName = data.categoryName;

          document.getElementById('firstImage')?.setAttribute('src', data.urlFirstImage);
          document.getElementById('secondImage')?.setAttribute('src', data.urlSecondImage);
          this.suggestedFunkos(data.categoryID);
        }
      );
  }

  quantityFunction(number: any) {
    this.quantity = parseInt(number.target.value);
  }

  onAddCart(id: any) {
    this.serviceFunko.search(id)
      .subscribe(
        data => {

          this.funkoName = data.name;
          this.funkoPrice = data.price;
          document.getElementById('firstImageCar')?.setAttribute('src', data.urlFirstImage);
          let funkoCart = {
            id: id,
            name: this.funkoName,
            description: data.description,
            urlFirstImage: data.urlFirstImage,
            price: data.price,
            quantity: this.quantity
          };

          this.cart.push(funkoCart);
          let currentCart = localStorage.getItem(this.FUNKOSCART);

          if (currentCart) {
            currentCart = JSON.parse(currentCart);
            let newCurrentCar = currentCart?.concat(JSON.stringify(funkoCart));
            this.storeInLocal(newCurrentCar);
          } else {
            this.storeInLocal(this.cart);
          }

          this.serviceCart.addingFunkoToCart();
        });
  }

  onFeed() {
    this.serviceFunko.filtering(this.filter, this.currentPage, this.itemsPerPage)
      .subscribe(
        data => {
          this.funkos = Object(data)['data'];
          
          this.numberOfRegs = Object(data)['regs'];
        }
        
      )

    }

  ngOnInit() {
   
    this.serviceCart.addingFunkoToCart();
    this.resetFilter();
  }

}

