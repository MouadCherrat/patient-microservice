import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Alert } from 'src/app/models/alert.model';

@Injectable({
  providedIn: 'root'
})
export class AlertService {
  private apiUrl = 'http://localhost:8091/api/alerts';

  constructor(private http: HttpClient) {}

  getAllAlerts(): Observable<Alert[]> {
    return this.http.get<Alert[]>(this.apiUrl);
  }

  getAlertById(id: number): Observable<Alert> {
    return this.http.get<Alert>(`${this.apiUrl}/${id}`);
  }

  createAlert(alert: Alert, patientId: number): Observable<Alert> {
    const params = new HttpParams().set('patientId', patientId.toString());
  
    return this.http.post<Alert>(this.apiUrl, alert, { params });
  }
  getPatientById(patientId: number): Observable<any> {
    return this.http.get<any>(`http://localhost:8082/api/patients/${patientId}`);
  }
  

  updateAlert(id: number, alert: Alert): Observable<Alert> {
    return this.http.put<Alert>(`${this.apiUrl}/${id}`, alert);
  }

  deleteAlert(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
