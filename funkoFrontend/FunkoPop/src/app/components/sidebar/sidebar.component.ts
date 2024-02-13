import { Component, OnInit, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/shared/services/auth.service';
import Swal from 'sweetalert2';
@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent {

  name:string = '';
  usuario: any;
  esRol1: boolean = false;
  router = inject(Router);

  constructor(private authService: AuthService) {}

  ngOnInit(): void {
    this.authService.usrActual.subscribe(res => {
      this.usuario = res;
      this.name=res.nombre;
      this.esRol1 = res.rol === 1;
    });
  }

  onSalir(): void {
    Swal.fire({
      title: "Session ended.",
      icon: 'success',
      showCancelButton: false,
      showConfirmButton: false,
      timer: 1500
    }).then((result) => {
      // Acción a realizar después de cerrar la alerta
      this.router.navigate(['']);
      this.authService.logout();
      // Puedes realizar aquí cualquier acción adicional que necesites
    });
    //this.authService.logout();
  }
}
