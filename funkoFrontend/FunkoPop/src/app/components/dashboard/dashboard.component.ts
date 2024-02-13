import { Component, inject } from '@angular/core'
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AdminModel } from 'src/app/shared/models/admin';
import { MainService } from 'src/app/shared/services/main.service';
import Swal from 'sweetalert2';


@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css', './css/styles.css']
})
export class DashboardComponent {
  router = inject(Router);
  titulo: string = '';
  srvMain = inject(MainService);
  fb = inject(FormBuilder);
  frmUser: FormGroup;
  filtro: any;
  pagActual = 1;
  itemsPPags = 5;
  admin = [new AdminModel];
  numRegs = 0;
  paginas = [2, 5, 10, 20, 50];
  idUsuario = 0;


  constructor() {
    this.frmUser = this.fb.group({
      idUsuario: [''],
      idRol: ['', [Validators.required]]
    });
  }


  get F() {
    return this.frmUser.controls;
  }

  onSubmit() {
    const idRol = {
      idRol: this.frmUser.value.idRol
    }
    this.srvMain.guardar(idRol, this.idUsuario)
      .subscribe({
        complete: () =>{
          Swal.fire({
            title: 'Rol Changed Sucessfully',
            icon: 'success',
            showCancelButton: true,
            showConfirmButton: false,
            cancelButtonColor: '#d33',
            cancelButtonText: 'Cerrar'
          });
          this.filtrar();
        },
        error: (e) => {
          if (e == 404) {
            Swal.fire({
              title: 'User not found',
              icon: 'success',
              showCancelButton: true,
              showConfirmButton: false,
              cancelButtonColor: '#d33',
              cancelButtonText: 'Cerrar'
            });

          }
        }
      });
  }


  onCambioPag(e: any) {
    this.pagActual = e;
    this.filtrar();

  }
  onCambioTama(e: any) {
    this.itemsPPags = e.target.value;
    this.pagActual = 1;
    this.filtrar();
  }
  onFiltroChange(f: any) {
    this.filtro = f;
    this.filtrar();
  }


  filtrar() {
    
    this.srvMain.filtrar(this.filtro, this.pagActual, this.itemsPPags)
      .subscribe(
        data => {
          console.log(data);
          this.admin = Object(data);
          this.numRegs = Object(data)['regs']
          console.log('Desde filtor  ' + this.admin);
        }
      );
  }

  resetearFiltro() {
    this.filtro = { id: '', emailAddress: '', id_person: '', password: '', userName: '', idRol: '' };
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
          }
        });
      }
    });
  }

  onEditarUser(id: any) {
    this.idUsuario = id;
  }
  
}