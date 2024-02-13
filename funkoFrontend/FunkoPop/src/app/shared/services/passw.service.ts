import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable, catchError, retry, throwError } from 'rxjs';
import { environment } from 'src/environments/environment.development';

@Injectable({
  providedIn: 'root'
})
export class PasswService {
  http = inject(HttpClient);
  SRV = environment.SRV;
  constructor() { }

    //se trabajó en clases
    changePassw(emailAddress: any, datos : {}) : Observable<any>{
      console.log(emailAddress);
      console.log(datos);
      return this.http.patch(`${this.SRV}/user/password/change-password/${emailAddress}`, datos)
      .pipe(retry(1), catchError(this.handleError));
  }

  private handleError(error:any){
    return throwError(
      ()=>{
        return error.status;
      }
    )
  }
}