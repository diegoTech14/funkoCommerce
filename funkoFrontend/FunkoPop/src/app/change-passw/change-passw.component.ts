import { Component, inject } from '@angular/core';
import { AbstractControlOptions, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/shared/services/auth.service';
import { PasswService } from 'src/app/shared/services/passw.service';
import { notEqualsValidator } from 'src/app/shared/validators/passw-equals';
import { passwStrengthValidator } from 'src/app/shared/validators/passw-strenght';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-change-passw',
  templateUrl: './change-passw.component.html',
  styleUrls: ['./change-passw.component.css']
})
export class ChangePasswComponent {

  frmChangePassw: FormGroup;
  fb = inject(FormBuilder);
  router = inject(Router)
  srvUsuario = inject(PasswService);
  authSrv = inject(AuthService);
  errorLogin: boolean = false;
  constructor() {
    this.frmChangePassw = this.fb.group({
      password: ['', Validators.required],
      passwordNew: ['', [Validators.required, Validators.minLength(8), passwStrengthValidator()]],
      passwR: ['', Validators.required]},
      {validator : notEqualsValidator()} as AbstractControlOptions
      )
  }

  get F (){
    return this.frmChangePassw.controls
  }

 onSubmit() {
    console.log(this.authSrv.valorUserActual.email);
    this.srvUsuario.changePassw(
      this.authSrv.valorUserActual.email,
      {
        password: this.frmChangePassw.value.password,
        passwordNew: this.frmChangePassw.value.passwordNew
      }
    ).subscribe({
      complete: () => {
        Swal.fire({
          title: "Successful password change",
          icon: 'success',
          showCancelButton: false,
          showConfirmButton: false,
          timer: 1000
        });
        this.onCerrar();
       },
      error: (error) => {
        Swal.fire({
          title: 'Error while changing password',
          icon: 'error',
          showCancelButton: true,
          showConfirmButton: false,
          cancelButtonColor: '#d33',
          cancelButtonText: 'Cerrar'
        });
      }
    })
  }

  onCerrar(){
    this.router.navigate([''])
  }
}