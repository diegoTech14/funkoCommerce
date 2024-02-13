import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment.development';
import { FunkoModel } from '../models/funko.models';
import { Observable, throwError } from 'rxjs';
import { catchError, retry } from 'rxjs/operators';


@Injectable({
    providedIn: 'root'
})

export class FunkoService {
    SERVICE = environment.SRV;

    httpOptions = {
        headers: new HttpHeaders({
          'Content-Type': 'Aplication/json'
        })
      };

    constructor(private http: HttpClient) { }

    save(datos: any, id?: any): Observable<any> {
        if (id) {//editar
          return this.http.put(`${this.SERVICE}/funko/${id}`, datos, this.httpOptions)
            .pipe(retry(1), catchError(this.handleError));
        } else {//crear
          return this.http.post(`${this.SERVICE}/funko`, datos, this.httpOptions)
            .pipe(retry(1), catchError(this.handleError));
        }
      }

    //suggested funkos
    filterCategorySuggested(id: any): Observable<FunkoModel[]> {
        return this.http.get<FunkoModel[]>(`${this.SERVICE}/funko/filter/categories/${id}`)
            .pipe(retry(1), catchError(this.handleError));
    }

    //search method
    search(id: any): Observable<FunkoModel> {
        return this.http.get<FunkoModel>(`${this.SERVICE}/funko/${id}`)
            .pipe(retry(1), catchError(this.handleError));
    }

    //filter method
    filtering(parameters: any, page: number, limit: number): Observable<FunkoModel[]> {
        let params = new HttpParams;
        for (const property in parameters) {
            if (property) {
                params = params.append(property, parameters[property]);
            }
        }
        return this.http.get<FunkoModel[]>(`${this.SERVICE}/funko/${page}/${limit}`, { params: params })
            .pipe(retry(1), catchError(this.handleError));
    }

    filterFeed(): Observable<FunkoModel[]> {
        return this.http.get<FunkoModel[]>(`${this.SERVICE}/funko/feed`)
            .pipe(retry(1), catchError(this.handleError));
    }

    delete(id: any): Observable<any> {

        return this.http.delete(`${this.SERVICE}/funko/${id}`)
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