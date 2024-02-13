import { Component, inject } from '@angular/core';
import { Form, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { FunkoModel } from 'src/app/shared/models/funko.models';
import { FunkoService } from 'src/app/shared/services/funko.service';
import { PrintService } from 'src/app/shared/services/print.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-funko-crud',
  templateUrl: './funko-crud.component.html',
  styleUrls: ['./funko-crud.component.css']
})
export class FunkoCrudComponent {
  router = inject(Router);
  formBuilder = inject(FormBuilder);
  serviceFunko = inject(FunkoService);
  servicePrint = inject(PrintService);
  formFunko: FormGroup;
  filter: any;
  currentPage = 1;
  itemsPerPage = 5;

  numberOfRegs = 0;
  pages = [2, 5, 10, 20, 50]
  funko = [new FunkoModel];
  idFunko = 0;
  urlFirstImage = "";
  urlSecondImage = "";
  nameFirstImage = "";
  nameSecondImage = "";
  imageLongDefault = 20;
  flagFirstImage = false;
  flagSecondImage = false;
  title = "";

  infoData = {
    id:0,
    urlFirstImage : "",
    urlSecondImage : "",
    name : "",
    description: "",
    price : 0,
    categoryName : "",
    ptypeName : "",
    codeCat : 0,
    codeType : 0
};

  constructor() {
    this.formFunko = this.formBuilder.group({
      id: [''],
      name: ['', [Validators.required]],
      typeName: [''],
      categoryID: ['', [Validators.required]],
      producttypesId: ['', [Validators.required]],
      categoryName: [''],
      exclusivity: ['', [Validators.required]],
      urlFirstImage: ['', [Validators.required]],
      urlSecondImage: ['', [Validators.required]],
      stock: ['', [Validators.required]],
      price: ['', [Validators.required]],
      description: ['', [Validators.required]]
    })
  }

  get FORM() {
    return this.formFunko.controls;
  }

  onSubmit() {
    const funko = {
      _name: this.formFunko.value.name,
      _producttypesId: this.formFunko.value.producttypesId,
      _categoryId: this.formFunko.value.categoryID,
      _exclusivity: this.formFunko.value.exclusivity,
      _urlFirstImage: this.nameFirstImage,
      _urlSecondImage: this.nameSecondImage,
      _stock: this.formFunko.value.stock,
      _price: this.formFunko.value.price,
      _description: this.formFunko.value.description
    }

    this.serviceFunko.save(funko, this.formFunko.value.id)
      .subscribe({
        complete: () => {
          Swal.fire({
            title: 'Funko Updated Sucessfully',
            icon: 'success',
            showCancelButton: true,
            showConfirmButton: false,
            cancelButtonColor: '#d33',
            cancelButtonText: 'Cerrar'
          });
          this.filteringFunkos();
        },
        error: (e) => {
          if (e == 404) {
            Swal.fire({
              title: 'Funko not found',
              icon: 'error',
              showCancelButton: true,
              showConfirmButton: false,
              cancelButtonColor: '#d33',
              cancelButtonText: 'Cerrar'
            });

          }else if(e == 401){
            Swal.fire({
              title: 'Unauthorized',
              icon: 'error',
              showCancelButton: true,
              showConfirmButton: false,
              cancelButtonColor: '#d33',
              cancelButtonText: 'Cerrar'
            });
          }
        }
      });

  }

  onFiltroChange(f:any){

    const emtpy = '';
    const newFilter = {
      id: emtpy,
      name: f.name,
    };

    this.filter = newFilter;
    this.filteringFunkos();
  }

  onImageSelected(event: any, imageFlag: number) {

    const file: File = event.target.files[0];
    if (file) {
      if (imageFlag == 1) {
        this.flagFirstImage = true;
        this.nameFirstImage = file.name;
      } else {
        this.flagSecondImage = true;
        this.nameSecondImage = file.name;
      }
    }
  }

  onNew() {
    this.title = "New Funko";
    this.urlFirstImage = "";
    this.urlSecondImage = "";
    this.formFunko.reset();
  }

  onChangePage(e: any) {
    this.currentPage = e;
    console.log(this.currentPage);
    this.filteringFunkos();
   
  }

  onChangeTama(e: any) {
    this.itemsPerPage = parseInt(e.target.value);
    this.currentPage = 1;
    this.filteringFunkos();
   
  }


  filteringFunkos() {

    this.serviceFunko.filtering(this.filter, this.currentPage, this.itemsPerPage)
      .subscribe(

        data => {
          this.funko = Object(data)['data'];
          this.numberOfRegs = Object(data)['regs'];
        }
      );
  }

  onDelete(id: any, nombre: string) {
    // Agregado de confirmación Noti
    Swal.fire({
      title: `Seguro que quieres eliminar al usuario ${nombre}`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Sí, eliminar!',
      cancelButtonText: 'Cancelar'
    }).then((result) => {
      if (result.isConfirmed) {
        this.serviceFunko.delete(id).subscribe({
          complete: () => {
            Swal.fire(
              'Eliminado!',
              'Cliente eliminado de forma correcta.',
              'success'
            );
            this.filteringFunkos();
          }
        });
      }
    });
  }

  evaluatingImageEvent(data: any) {
    this.nameFirstImage = "";
    this.nameSecondImage = "";
    if (this.flagFirstImage == false) {
      this.nameFirstImage = data.urlFirstImage.substring(this.imageLongDefault);
    }

    if (this.flagSecondImage == false) {
      this.nameSecondImage = data.urlSecondImage.substring(this.imageLongDefault);
    }
  }

  onEditFunko(id: any) {
    this.title = "Edit Funko";
    this.serviceFunko.search(id).subscribe({
      next: (data) => {


        this.urlFirstImage = data.urlFirstImage;
        this.urlSecondImage = data.urlSecondImage;

        this.evaluatingImageEvent(data);
        this.formFunko.setValue(data);

      },
      error: (e) => {
        if (e === 404) {
          Swal.fire({
            title: 'Funko Not Found',
            icon: 'error',
            showCancelButton: true,
            showConfirmButton: false,
            cancelButtonColor: '#d33',
            cancelButtonText: 'Close'
          });
        }
        this.filteringFunkos();
      }
    })
  }

  resetFilter() {
    this.filter = { id: '', name: '', productTypeID: '', categoryID: '', exclusivity: '' };
    this.filteringFunkos();
  }

  onInfo(id : any){
    this.serviceFunko.search(id)
      .subscribe(
        data => {
            if(data.id){
              this.infoData.id = data.id;
            }
            this.infoData.urlFirstImage = data.urlFirstImage;
            this.infoData.urlSecondImage = data.urlSecondImage;
            this.infoData.name = data.name;
            this.infoData.description = data.description;
            this.infoData.categoryName = data.categoryName;
            this.infoData.ptypeName = data.typeName;
            this.infoData.codeCat = data.categoryID;
            this.infoData.codeType = data.productID;
            this.infoData.price = data.price;
            

            
        }
      )
  }

  onPrint(){
    const header = ["Funko ID", "Name", "Prod. Type", "Category", "Stock", "Price"];
    this.serviceFunko.filtering(this.filter, 1, this.numberOfRegs)
      .subscribe(
        data => {
          console.log(data);
          const body = Object(data)['data']
            .map(
              (Obj : any) => {
                const data = [
                  Obj.id,
                  Obj.name, 
                  Obj.typeName,
                  Obj.categoryName,
                  Obj.stock,
                  "$"+Obj.price + ".00"
                ]
                return data;
              }
            )
            this.servicePrint.print(header, body, "Funko List", true);
        }        
      )
  }

  ngOnInit() {
    this.resetFilter();
  }
}
