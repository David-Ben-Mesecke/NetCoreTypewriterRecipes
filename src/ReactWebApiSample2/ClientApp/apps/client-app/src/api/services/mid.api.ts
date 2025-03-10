﻿
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'

import { environment } from '../../environments/environment';

import * as qs from 'qs';
import { SimpleModel } from '../models/SimpleModel';


const getUrl = () => {
  if(environment.apiBaseUrl) {
    return environment.apiBaseUrl.endsWith('/') ?
      `${environment.apiBaseUrl}api/Mid` :
      `${environment.apiBaseUrl}/api/Mid`;
  }

  return 'api/Mid';
}; 

const midServiceUrl = getUrl();

export const midApi = createApi({
  reducerPath: 'midApi',
  baseQuery: fetchBaseQuery({ baseUrl: environment.apiBaseUrl }),
  endpoints: (builder) => ({
  
  
  
  
    postSimpleModel: builder.mutation<SimpleModel, SimpleModel>({
      query: (value) => {
        
        
        const body=value;
        
        
        return {
          url: midServiceUrl,
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
  
  
  
    getstring: builder.query<SimpleModel, string>({
      query: (id) => {
        
        const paramObj = {
          id: id
        };
        const queryPath = qs.stringify(paramObj);
        const url = midServiceUrl + '?' + queryPath;
        
        

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
  usePostSimpleModelMutation,
  useGetstringQuery
} = midApi;

