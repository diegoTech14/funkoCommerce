import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AdminModel } from 'src/app/shared/models/admin';
import { MainService } from 'src/app/shared/services/main.service';
import { PrintService } from 'src/app/shared/services/print.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-user-crud',
  templateUrl: './user-crud.component.html',
  styleUrls: ['./user-crud.component.css']
})
export class UserCrudComponent {
  router=inject(Router);

  titulo: string = '';
  srvMain = inject(MainService);
  fb = inject(FormBuilder);
  frmUser : FormGroup;
  filtro: any;
  pagActual = 1;
  itemsPPags = 5;
  admin = [new AdminModel];
  numRegs = 0;
  paginas = [2, 5, 10, 20, 50];
  idUsuario=0;
  srvPrint=inject(PrintService);
  filtroVisible : boolean = false;


  constructor() {
    this.frmUser = this.fb.group({
      idUsuario: [''],
      idRol: ['',[Validators.required]]
    });
  }

  onPrint(){

    const encabezado = ["ID", "Email Adress", "ID Person", "User Name","Id Rol","Last Access"];
    this.srvMain.filtrar(this.filtro, 1 , this.numRegs)
    .subscribe(
      data => {
        const cuerpo= Object(data)['data']
          .map(
             (Obj : any)=> {
              console.log(Obj);
               const datos = [
               Obj.id,
               Obj.emailAddress,
               Obj.id_person,
               Obj.userName,
               Obj.idRol,
               Obj.lastAccess
            ]
            return datos;
          }
        )
        this.srvPrint.print(encabezado, cuerpo, "Listado de Clientes", true);
      }
    )

  }
  get F() {
    return this.frmUser.controls;
  }

  onSubmit() {//Guardar
    //validacion para el boton de guardado que ya se hace en el html
    //if(this.frmCliente.invalid) return;

    const cliente = {
      idRol: this.frmUser.value.idRol
    }
    console.log("SOY CLIENTE",this.frmUser.value.idRol);
    this.srvMain.guardar(cliente, this.idUsuario)
      .subscribe({
        
       complete: () => {
                Swal.fire(
                  'Cambio de Rol EXITOSO!',
                  'Cambio de Rol asignado de forma correcta.',
                  'success'
                );
                this.filtrar();
              }
});
  }












  onCambioPag(e: any){
    this.pagActual = e;
    this.filtrar();
  }

  onCambioTama(e: any){
    this.itemsPPags = e.target.value;
    this.pagActual = 1;
    this.filtrar();

  }
  
  onFiltroChange(f:any){
    console.log("On Filtro Change",f)
    const vacio='';
    const nuevoFiltro = {
      nuevoCampo1: vacio,
      emailAddress: f.emailAddress,

    };
  
    this.filtro = nuevoFiltro;
    this.filtrar();
    }

    
  filtrar() {
    this.srvMain.filtrar(this.filtro, this.pagActual, this.itemsPPags)    
      .subscribe(
        data => {
          console.log(data);
          this.admin = Object(data)['data'];
          this.numRegs = Object(data)['regs'];
          console.log('Desde filtor',data);
        }
      );
  }

  resetearFiltro(){
    this.filtro = { id: '', emailAddress: '', id_person: '', password: '',userName: '',idRol: ''};
    this.filtrar();
  }

  ngOnInit() {
    this.resetearFiltro();
    
      }

      onEliminar(id: any, nombre: string) {
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
            this.srvMain.eliminar(id).subscribe({
              complete: () => {
                Swal.fire(
                  'Eliminado!',
                  'Cliente eliminado de forma correcta.',
                  'success'
                );
                this.filtrar();
              },
            });
          }
        });
      }

onEditarUser(id : any){
this.idUsuario=id;
}
      onEditar(id : any){
        this.titulo = 'Editar Cliente';
        this.srvMain.buscar(id).subscribe({
          next : (data) => {
            this.frmUser.setValue(data);
          },
          error: (e) => {
            if(e === 404){
              Swal.fire({
                title: 'Cliente no existe',                             
                icon: 'error',
                showCancelButton: true,
                showConfirmButton: false,                
                cancelButtonColor: '#d33',                
                cancelButtonText : 'Cerrar'  
              });
            }
          this.filtrar();
        }  
      })
        console.log("editando",id);
      }



      onInfo(id: any) {
        
        this.srvMain.buscarPersona(id)
        .subscribe(
          data => {
        console.log(data);
                Swal.fire({
                  title: '<strong>Informacion de Usuario</strong>',
                  html : '<br>'+'<table class="table table-sm table-striped">'+
                  '<tbody class="text-start">'+
                  '<tr><th> Id Persona </th>'+`<td>${data.id}</td></tr>`+
                  '<tr><th> Nombre </th>'+`<td>${data.name}  ${data.surnameOne} ${data.surnameOne}</td></tr>`+
                  '</tbody>'+
                  '</table>',
                  icon: 'info',
                  showCancelButton: true,
                  showConfirmButton: false,
                  cancelButtonColor: '#d33',
                  cancelButtonText: 'Cerrar'
                });

            });
         
      
          }
          onFiltrar(){
            this.filtroVisible = !this.filtroVisible;
            if(!this.filtroVisible){
              this.resetearFiltro();
            }
              }        
              get stateFiltro(){
                return this.filtroVisible ? 'show' : 'hide';
              }
}