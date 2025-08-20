
import { HttpParams } from "@angular/common/http";
// export const API_BASE_URL = "http://localhost:8080/api/v1";
export const API_BASE_URL = "https://apicollabdev-2.onrender.com/api/v1/";
export function apiUrl(path: string) {
  if (!path.startsWith("/")) path = `/${path}`;
  return `${API_BASE_URL}${path}`;
}

export type Primitive = string | number | boolean | undefined | null;

export function buildHttpParams(obj?: Record<string, Primitive | Primitive[]>) {
  
  let params = new HttpParams();
  if (!obj) return params;
  Object.entries(obj).forEach(([key, value]) => {
    if (value === undefined || value === null) return;
    if (Array.isArray(value)) {
      value.forEach((v) => {
        if (v !== undefined && v !== null) {
          params = params.append(key, String(v));
        }
      });
    } else {
      params = params.set(key, String(value));
    }
  });
  return params;
}
