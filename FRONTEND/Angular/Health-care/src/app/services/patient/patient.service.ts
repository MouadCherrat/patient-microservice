import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Patient } from 'src/app/models/patient.model';

@Injectable({
  providedIn: 'root',
})
export class PatientService {
  private baseUrl = 'http://localhost:8091/api/patients'; // URL de base pour l'API backend

  constructor(private http: HttpClient) {}

  // Récupérer tous les patients
  getAll(): Observable<Patient[]> {
    return this.http.get<Patient[]>(this.baseUrl);
  }

  // Récupérer un patient par ID
  getById(id: number): Observable<Patient> {
    return this.http.get<Patient>(`${this.baseUrl}/${id}`);
  }

  // Créer un nouveau patient
  create(patient: Patient): Observable<Patient> {
    return this.http.post<Patient>(this.baseUrl, patient);
  }

  // Mettre à jour un patient existant
  update(id: number, patient: Patient): Observable<Patient> {
    return this.http.put<Patient>(`${this.baseUrl}/${id}`, patient);
  }

  // Supprimer un patient par ID
  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  // Récupérer des patients par ID de docteur (exemple : `/api/patients/by-doctor?doctorId=1`)
  getPatientsByDoctor(doctorId: number): Observable<Patient[]> {
    return this.http.get<Patient[]>(`${this.baseUrl}/by-doctor?doctorId=${doctorId}`);
  }
}
