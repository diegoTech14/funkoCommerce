import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';
import { environment } from 'src/environments/environment.development';
import { AdminModel } from '../models/admin';

@Injectable({
  providedIn: 'root'
})
export class MainService {
  SERVICE = environment.SRV;
  //Nuevo
  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'Aplication/json'
    })
  };

  constructor(private http: HttpClient) { }
  guardar(datos: any, id?: any): Observable<any> {
    if (id) {//editar
      return this.http.put(`${this.SERVICE}/user/rol/${id}`, datos, this.httpOptions)
        .pipe(retry(1), catchError(this.handleError));
    } else {//crear
      return this.http.post(`${this.SERVICE}/person`, datos, this.httpOptions)
        .pipe(retry(1), catchError(this.handleError));
    }
  }

  filtrar(parametros: any, pag: number, lim: number): Observable<AdminModel[]> {
    let params = new HttpParams;
    for (const prop in parametros) {
      if (prop) {
        params = params.append(prop, parametros[prop])
      }
    }
    console.log(params, pag, lim);
    return this.http.get<AdminModel[]>(`${this.SERVICE}/user/${pag}/${lim}`, { params: params })
      .pipe(retry(1), catchError(this.handleError));

  }
  
  eliminar(id: any): Observable<any> {

    return this.http.delete(`${this.SERVICE}/user/${id}`)
      .pipe(retry(1), catchError(this.handleError));
  }

  //Ojooooooooooooo Nuevooooooooooooooooooooo
  buscarPersona (id: any) : Observable<AdminModel>{

    return this.http.get<AdminModel>(`${this.SERVICE}/person/${id}`)
    .pipe(retry(1), catchError(this.handleError));
  }

  private handleError(error: any) {

    return throwError(
      () => {
        return error.status;
      }
    )
  }

  buscar(id: any): Observable<AdminModel> {
    return this.http.get<AdminModel>(`${this.SERVICE}/user/${id}`)
      .pipe(retry(1), catchError(this.handleError));
  }

}