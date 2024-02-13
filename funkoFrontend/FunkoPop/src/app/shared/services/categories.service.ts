import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment.development';

import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { CategoryModel } from '../models/categories';

@Injectable({
  providedIn: 'root'
})
export class CategoriesService {

  SERVICE = environment.SRV;

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'Aplication/json'
    })
  };

  constructor(private http: HttpClient) { }

  save(datos: any, id?: any): Observable<any> {
    if (id) {
      return this.http.put(`${this.SERVICE}/categories/edit/${id}`, datos, this.httpOptions)
        .pipe(retry(1), catchError(this.handleError));
    } else {
      return this.http.post(`${this.SERVICE}/categories/`, datos, this.httpOptions)
        .pipe(retry(1), catchError(this.handleError));
    }
  }

  filtering(parameters: any, page: number, limit: number): Observable<CategoryModel[]> {
    let params = new HttpParams;
    for (const property in parameters) {
      if (property) {
        params = params.append(property, parameters[property]);
      }
    }
    return this.http.get<CategoryModel[]>(`${this.SERVICE}/categories/all/${page}/${limit}`, { params: params })
      .pipe(retry(1), catchError(this.handleError));
  }

  delete(id: any): Observable<any> {

    return this.http.delete(`${this.SERVICE}/categories/delete/${id}`)
      .pipe(retry(1), catchError(this.handleError));
  }

  search(id: any): Observable<CategoryModel> {
    return this.http.get<CategoryModel>(`${this.SERVICE}/categories/${id}`)
        .pipe(retry(1), catchError(this.handleError));
}

  private handleError(error: any) {
    return throwError(
        () => {
            console.log(error);
            return error.status;
        }
    )
}
}
