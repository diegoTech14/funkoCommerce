import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MainService } from '../shared/services/main.service';
import Swal from 'sweetalert2';
import { Router } from '@angular/router';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent {
  titulo : string ='';
 srvPerson=inject(MainService);
 router=inject(Router);
  fb =inject(FormBuilder);
  frmRegister : FormGroup;

  constructor(){
    this.frmRegister = this.fb.group({
      id: [''],
      name :[''],
      surNameOne :[''],
      surNameTwo :[''],
      emailAddress :[''],
      password :[''],
      userName :[''],
     

    })
  }
  onNuevo(){
    this.titulo="Nuevo Cliente"
    console.log("Creando Nuevo");
    this.frmRegister.reset()
  }
  onSubmit() {//Guardar
    //validacion para el boton de guardado que ya se hace en el html
    //if(this.frmCliente.invalid) return;

    const cliente = {
      name: this.frmRegister.value.name,
      surNameOne: this.frmRegister.value.surNameOne,
      surNameTwo: this.frmRegister.value.surNameTwo,
      password: this.frmRegister.value.password,
      emailAddress: this.frmRegister.value.emailAddress,
      userName: this.frmRegister.value.userName
  }


const texto = this.frmRegister.value.id ? 'Cambios guardados!!!' : 'Creado con Exito!!!'

   this.srvPerson.guardar(cliente, this.frmRegister.value.id)
      .subscribe({
       complete : () => {
        Swal.fire({
          title: texto,
          icon: 'success',
          showCancelButton: false,
          showConfirmButton: false,
          timer: 1000
        }).then(() => {
         this.router.navigate(['/feed']);
        });
        
       },
       error : (e) => {
        switch(e){
          case 404:
            Swal.fire({
              title: 'Cliente no existe',
              icon: 'error',
              showCancelButton: true,
              showConfirmButton: false,
              cancelButtonColor: '#d33',
              cancelButtonText: 'Cerrar'
            });
            break;

            case 409:
              Swal.fire({
                title: 'idCliente ya existe',
                icon: 'error',
                showCancelButton: true,
                showConfirmButton: false,
                cancelButtonColor: '#d33',
                cancelButtonText: 'Cerrar'
              });
            break;
          }
  }
});
  }
  
  
}