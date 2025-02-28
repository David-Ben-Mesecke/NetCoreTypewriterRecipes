﻿
import { Inject, Injectable, Optional } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

import { Observable } from 'rxjs';

import { API_BASE_URL } from '../../app/app-config.module';


import { HttpParamsProcessorService } from '@adaskothebeast/http-params-processor';
import { CombinedResultModel } from '../models/CombinedResultModel';
import { CombinedQueryModel } from '../models/CombinedQueryModel';



interface Object {
  hasOwnProperty<TK extends string>(v: TK): this is Record<TK, object>;
}

export interface IApiComplexService {
    postCombinedResultModel(value: CombinedResultModel): Observable<CombinedResultModel>;
    getCombinedQueryModel(query: CombinedQueryModel): Observable<CombinedResultModel>;
}

@Injectable(
    { providedIn: 'root' }
)
export class ApiComplexService implements IApiComplexService {
    constructor (
      @Inject(HttpClient) protected http: HttpClient,
      @Inject(HttpParamsProcessorService) protected processor: HttpParamsProcessorService,
      @Optional() @Inject(API_BASE_URL) protected baseUrl?: string) {
    }

    public get complexServiceUrl(): string {
        if (this.baseUrl) {
            return this.baseUrl.endsWith('/') ? this.baseUrl + 'api/Complex' : this.baseUrl + '/' + 'api/Complex';
        } else {
            return 'api/Complex';
        }
    }





    public postCombinedResultModel(value: CombinedResultModel): Observable<CombinedResultModel> {
        const headers = new HttpHeaders()
            .set('Content-Type', 'application/json')
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        return this.http.post<CombinedResultModel>(
            this.complexServiceUrl + '',
            value,
            {
                headers
            });
    }

    public getCombinedQueryModel(query: CombinedQueryModel): Observable<CombinedResultModel> {
        const headers = new HttpHeaders()
            .set('Accept', 'application/json')
            .set('If-Modified-Since', '0');

        let params = new HttpParams();

        const parr = [];

        parr.push(query);
        params = this.processor.processWithParams(params, 'query', parr.pop());

        return this.http.get<CombinedResultModel>(
            this.complexServiceUrl + '',
            {
                headers,
                params
            });
    }





}
