﻿
import { Inject, Injectable, Optional } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

import { Observable } from 'rxjs';

import { API_BASE_URL } from '../../app/app-config.module';


import { HttpParamsProcessorService } from '@adaskothebeast/http-params-processor';



interface Object {
  hasOwnProperty<TK extends string>(v: TK): this is Record<TK, object>;
}

export interface IApiSimpleService {
    get(): Observable<string[]>;
    getnumber(id: number): Observable<string>;
    poststring(value: string): Observable<void>;
    deletenumber(id: number): Observable<void>;
}

@Injectable(
    { providedIn: 'root' }
)
export class ApiSimpleService implements IApiSimpleService {
    constructor (
      @Inject(HttpClient) protected http: HttpClient,
      @Inject(HttpParamsProcessorService) protected processor: HttpParamsProcessorService,
      @Optional() @Inject(API_BASE_URL) protected baseUrl?: string) {
    }

    public get simpleServiceUrl(): string {
        if (this.baseUrl) {
            return this.baseUrl.endsWith('/') ? this.baseUrl + 'api/Simple' : this.baseUrl + '/' + 'api/Simple';
        } else {
            return 'api/Simple';
        }
    }

    public get(): Observable<string[]> {
        const headers = new HttpHeaders()
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        let params = new HttpParams();



        return this.http.get<string[]>(
            this.simpleServiceUrl + '',
            {
                headers,
                params
            });
    }





    public getnumber(id: number): Observable<string> {
        const headers = new HttpHeaders()
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        let params = new HttpParams();

        const parr = [];

        parr.push(id);
        params = this.processor.processWithParams(params, 'id', parr.pop());

        return this.http.get<string>(
            this.simpleServiceUrl + '/{id}',
            {
                headers,
                params
            });
    }








    public poststring(value: string): Observable<any> {
        const headers = new HttpHeaders()
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        return this.http.post(
            this.simpleServiceUrl + '',
            value,
            {
                headers,
                responseType: 'text'
            });
    }







    public deletenumber(id: number): Observable<void> {
        const headers = new HttpHeaders()
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        let params = new HttpParams();

        const parr = [];

        parr.push(id);
        params = this.processor.processWithParams(params, 'id', parr.pop());

        return this.http.delete<void>(
            this.simpleServiceUrl + '/{id}',
            {
                headers,
                params
            });
    }
}
