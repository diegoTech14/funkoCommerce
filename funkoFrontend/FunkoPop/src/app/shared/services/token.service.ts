import { HttpClient } from '@angular/common/http';
import { Token } from '../models/token';
import { Injectable, inject } from '@angular/core';
import {JwtHelperService} from '@auth0/angular-jwt';
import { environment } from 'src/environments/environment.development';


@Injectable({
  providedIn: 'root'
})
export class TokenService {
  private JWT_TOKEN= 'JWT_TOKEN';
  private REFRESH_TOKEN='REFRESH_TOKEN';
  http=inject(HttpClient);
  SRV=environment.SRV;;
  refrescando: boolean=false;

  constructor() {

   }
   setTokens(tokens : Token):void{
    this.setToken(tokens.token);
    this.setRefreshToken(tokens.refreshToken);

  }
  private setToken(token:string):void{
    localStorage.setItem(this.JWT_TOKEN,token);

  }
  
  private setRefreshToken(token:string):void{
    localStorage.setItem(this.REFRESH_TOKEN, token);
  }

  get token(): any{
    return localStorage.getItem(this.JWT_TOKEN);
  }

  eliminarTokens(){
    localStorage.removeItem(this.JWT_TOKEN);
    localStorage.removeItem(this.REFRESH_TOKEN);
  }

  
  get refreshToken() : any { // obtener
    return localStorage.getItem(this.REFRESH_TOKEN);
 }

  
  public decodeToken():any{
    const helper =new JwtHelperService();
    return helper.decodeToken(this.token);

  }


  jwtTokenExp():any{
    const helper =new JwtHelperService();
    return helper.isTokenExpired(this.token);
    

  }
  public  tiempoExpToken():any{
    return this.decodeToken().exp - (Date.now()/1000);
  }

  public refreshTokens(){
    if (!this.refrescando) {
      this.refrescando=true;
      this.http.patch<Token>(`${this.SRV}/session/refreshSession/${this.decodeToken().sub}`,
      {tkRef:`${this.refreshToken}`})
      .subscribe(
        tokens=>{
          this.setTokens(tokens);
          this.refrescando= false;
        }


      );
    }

}
}