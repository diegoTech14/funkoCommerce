import { Component, inject } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';

import { AuthService } from 'src/app/shared/services/auth.service';
import Swal from 'sweetalert2';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  frmLogin: FormGroup
  fb= inject(FormBuilder);
  srvAuth=inject(AuthService);
  errorLogin : boolean=false;

  constructor(){
    this.frmLogin = this.fb.group({
      emailAddress :['', Validators.required],
      password :['', Validators.required],

    })
  }
  onSubmit(){
    this.srvAuth.login(this.frmLogin.value)
    .subscribe(
      res=>{
        this.errorLogin =(!res || res===401)
        if (this.errorLogin) {
          Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'User or password are incorrect',
          });
        }
      }

    )
  }
}
