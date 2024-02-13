import { Component, inject } from '@angular/core';
import { Form, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CategoryModel } from 'src/app/shared/models/categories';
import { CategoriesService } from 'src/app/shared/services/categories.service';
import { PrintService } from 'src/app/shared/services/print.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-categories',
  templateUrl: './categories.component.html',
  styleUrls: ['./categories.component.css']
})
export class CategoriesComponent {

  router = inject(Router);
  formBuilder = inject(FormBuilder);
  serviceCategory = inject(CategoriesService);
  servicePrint = inject(PrintService);
  formCategories: FormGroup;
  title = "Category Form";


  category = [new CategoryModel];
  filter: any;
  currentPage = 1;
  itemsPerPage = 5;
  numberOfRegs = 0;
  pages = [2, 5, 10, 20, 50]


  constructor() {
    this.formCategories = this.formBuilder.group({
      id: ['', [Validators.required]],
      categoryName: ['', [Validators.required]],
    })
  }

  get FORM() {
    return this.formCategories.controls;
  }

      
  onNew() {
    this.title = "New Funko";
    this.formCategories.reset();
  }
  onSubmit(){
    const category = {
      _name: this.formCategories.value.categoryName
    }
    console.log(this.formCategories.value.id);
    this.serviceCategory.save(category, this.formCategories.value.id)
      .subscribe({
        complete: () => {
          Swal.fire({
            title: 'Category Created Sucessfully',
            icon: 'success',
            showCancelButton: true,
            showConfirmButton: false,
            cancelButtonColor: '#d33',
            cancelButtonText: 'Cerrar'
          });
          this.filteringCategories();
        },
        error: (e) => {
          if (e == 404) {
            Swal.fire({
              title: 'Category not found',
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

  onChangePage(e: any) {
    this.currentPage = e;
    console.log(this.currentPage);
    this.filteringCategories();
   
  }

  onChangeTama(e: any) {
    this.itemsPerPage = parseInt(e.target.value);
    this.currentPage = 1;
    this.filteringCategories();
  }


  resetFilter() {
    this.filter = { id: '', categoryName: ''};
    this.filteringCategories();
  }

  filteringCategories() {

    this.serviceCategory.filtering(this.filter, this.currentPage, this.itemsPerPage)
      .subscribe(

        data => {
          this.category = Object(data)['data'];
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
        this.serviceCategory.delete(id).subscribe({
          complete: () => {
            Swal.fire(
              'Eliminado!',
              'Cliente eliminado de forma correcta.',
              'success'
            );
            this.filteringCategories();
          }
        });
      }
    });
  }

  onEdit(id: any) {
    console.log("Este es el ID: ",id);
    this.title = "Edit Category";
    this.serviceCategory.search(id).subscribe({
      next: (data) => {
        console.log("datos: ",data)
        this.formCategories.setValue(data);
        console.log(this.formCategories.controls);
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
        this.filteringCategories();
      }
    })
  }

  onPrint(){
    const header = ["Funko ID", "Name"];
    this.serviceCategory.filtering(this.filter, 1, this.numberOfRegs)
      .subscribe(
        data => {

          const body = Object(data)['data']
            .map(
              (Obj : any) => {
                const data = [
                  Obj.id,
                  Obj.categoryName
                ]
                return data;
              }
            )
            this.servicePrint.print(header, body, "Categories", true);
        }        
      )
  }

  ngOnInit() {
    this.resetFilter();

  }

}
