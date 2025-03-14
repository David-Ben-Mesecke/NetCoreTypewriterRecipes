﻿
import { Inject, Injectable, Optional } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

import { Observable } from 'rxjs';

import { API_BASE_URL } from '../../app/app-config.module';


import { HttpParamsProcessorService } from '@adaskothebeast/http-params-processor';
import { SimpleModel } from '../models/SimpleModel';



interface Object {
  hasOwnProperty<TK extends string>(v: TK): this is Record<TK, object>;
}

export interface IApiMidService {
    postSimpleModel(value: SimpleModel): Observable<SimpleModel>;
    getstring(id: string): Observable<SimpleModel>;
}

@Injectable(
    { providedIn: 'root' }
)
export class ApiMidService implements IApiMidService {
    constructor (
      @Inject(HttpClient) protected http: HttpClient,
      @Inject(HttpParamsProcessorService) protected processor: HttpParamsProcessorService,
      @Optional() @Inject(API_BASE_URL) protected baseUrl?: string) {
    }

    public get midServiceUrl(): string {
        if (this.baseUrl) {
            return this.baseUrl.endsWith('/') ? this.baseUrl + 'api/Mid' : this.baseUrl + '/' + 'api/Mid';
        } else {
            return 'api/Mid';
        }
    }





    public postSimpleModel(value: SimpleModel): Observable<SimpleModel> {
        const headers = new HttpHeaders()
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        return this.http.post<SimpleModel>(
            this.midServiceUrl + '',
            value,
            {
                headers
            });
    }

    public getstring(id: string): Observable<SimpleModel> {
        const headers = new HttpHeaders()
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        let params = new HttpParams();

        const parr = [];

        parr.push(id);
        params = this.processor.processWithParams(params, 'id', parr.pop());

        return this.http.get<SimpleModel>(
            this.midServiceUrl + '',
            {
                headers,
                params
            });
    }





}
