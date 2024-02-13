import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Token } from '../models/token';
import { Observable, catchError, map, retry, tap, of, BehaviorSubject } from 'rxjs';
import { TokenService } from './token.service';
import { Router } from '@angular/router';
import { User } from '../models/user';
import { environment } from 'src/environments/environment.development';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  servidor=environment.SRV;;
  http=inject(HttpClient);
  srvToken= inject(TokenService);
  router=inject(Router);//redirgir login
  private usrActualSubject= new BehaviorSubject<User>(new User());
  public usrActual = this.usrActualSubject.asObservable();
  constructor() { }

   public login(user:{emailAddress:'',password:''}):Observable<any>{


    return this.http.patch<Token>(`${this.servidor}/session/initSession/${user.emailAddress}`,{password:user.password})
    .pipe(
      retry(1),
      tap(
        tokens =>{
          this.doLogin(tokens);
          console.log(tokens);

          this.router.navigate(['']);
        }
      ),
      map(()=>true),
      catchError(
        error=>{return of (error.status)}
      )
    )
   }

   public logout(){
    this.http.patch(`$(this.SRV/session/closeSession/${this.valorUserActual.email})`,{})
    .subscribe()
      this.doLogout();
 
  }
  private doLogout(){
    if (this.srvToken.token) {
      this.srvToken.eliminarTokens();
      localStorage.clear();
    }
    this.usrActualSubject.next(this.getUserActual());
  }

  private doLogin(tokens:Token):void{
    this.srvToken.setTokens(tokens);
    this.usrActualSubject.next(this.getUserActual());

  }

 

  public get valorUserActual():User{
    return this.usrActualSubject.value;
  }

  private getUserActual():User{
    if (!this.srvToken.token) {
      return new User();
    }

    console.log()
    const tokenD=this.srvToken.decodeToken();
    console.log("Token D",tokenD);
    return {email: tokenD.sub, nombre:tokenD.nom,rol: tokenD.rol};
  }

public issLogged():boolean{
  return !!this.srvToken.token && !this.srvToken.jwtTokenExp();
}
public verifiRefrescas():boolean{
  if (this.issLogged()&&this.srvToken.tiempoExpToken()<=20) {
    this.srvToken.refreshTokens();
    return true;
  }
  return false;
}

}