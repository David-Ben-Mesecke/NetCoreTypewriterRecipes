﻿
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'

import { environment } from '../../environments/environment';

import * as qs from 'qs';
import { CombinedResultModel } from '../models/CombinedResultModel';
import { CombinedQueryModel } from '../models/CombinedQueryModel';


const getUrl = () => {
  if(environment.apiBaseUrl) {
    return environment.apiBaseUrl.endsWith('/') ?
      `${environment.apiBaseUrl}api/Complex` :
      `${environment.apiBaseUrl}/api/Complex`;
  }

  return 'api/Complex';
}; 

const complexServiceUrl = getUrl();

export const complexApi = createApi({
  reducerPath: 'complexApi',
  baseQuery: fetchBaseQuery({ baseUrl: environment.apiBaseUrl }),
  endpoints: (builder) => ({
  
  
  
  
    postCombinedResultModel: builder.mutation<CombinedResultModel, CombinedResultModel>({
      query: (value) => {
        
        
        const body=value;
        
        
        return {
          url: complexServiceUrl,
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'If-Modified-Since': '0',
          },
          body: body
        };
      },
    }),
  
  
  
    getCombinedQueryModel: builder.query<CombinedResultModel, CombinedQueryModel>({
      query: (query) => {
        
        const paramObj = {
          query: query
        };
        const queryPath = qs.stringify(paramObj);
        const url = complexServiceUrl + '?' + queryPath;
        
        

        return {
          url: url,
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'If-Modified-Since': '0',
          }
        };
      },
    }),
  
  
  
  
  
  
  
  })
});    

export const {
  usePostCombinedResultModelMutation,
  useGetCombinedQueryModelQuery
} = complexApi;

