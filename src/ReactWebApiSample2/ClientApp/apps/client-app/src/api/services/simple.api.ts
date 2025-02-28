﻿
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'

import { environment } from '../../environments/environment';

import * as qs from 'qs';


const getUrl = () => {
  if(environment.apiBaseUrl) {
    return environment.apiBaseUrl.endsWith('/') ?
      `${environment.apiBaseUrl}api/Simple` :
      `${environment.apiBaseUrl}/api/Simple`;
  }

  return 'api/Simple';
}; 

const simpleServiceUrl = getUrl();

export const simpleApi = createApi({
  reducerPath: 'simpleApi',
  baseQuery: fetchBaseQuery({ baseUrl: environment.apiBaseUrl }),
  endpoints: (builder) => ({
    get: builder.query<string[], void>({
      query: () => {
        
        
        const url = simpleServiceUrl;
        

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
  
  
  
  
  
  
  
    getnumber: builder.query<string, number>({
      query: (id) => {
        
        const paramObj = {
          id: id
        };
        const queryPath = qs.stringify(paramObj);
        const url = simpleServiceUrl + '?' + queryPath;
        
        

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
  
  
  
  
  
  
  
  
  
  
    poststring: builder.mutation<void, string>({
      query: (value) => {
        
        
        const body=value;
        
        
        return {
          url: simpleServiceUrl,
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
  
  
  
  
  
  
  
  
  
    deletenumber: builder.mutation<void, number>({
      query: (id) => {
        
        
        const body=id;
        
        
        return {
          url: simpleServiceUrl,
          method: 'DELETE',
          headers: {
            'Accept': 'application/json',
            'If-Modified-Since': '0',
          },
          body: body
        };
      },
    }),
  
  
  })
});    

export const {
  useGetQuery,
  useGetnumberQuery,
  usePoststringMutation,
  useDeletenumberMutation
} = simpleApi;

