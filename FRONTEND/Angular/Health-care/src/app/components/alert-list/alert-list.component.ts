import { Component, OnInit } from '@angular/core';
import { AlertService } from 'src/app/services/alert/alert.service';
import { Alert } from 'src/app/models/alert.model';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Patient } from 'src/app/models/patient.model';

@Component({
  selector: 'app-alert-list',
  templateUrl: './alert-list.component.html',
  styleUrls: ['./alert-list.component.css']
})
export class AlertListComponent implements OnInit {
  alerts: Alert[] = [];
  patientsMap: Map<number, string> = new Map();
  loading: boolean = false;
  error: string | null = null;

  constructor(private alertService: AlertService, private http: HttpClient, private router: Router) {}

  ngOnInit(): void {
    this.loadAlerts();
    this.loadPatients();
  }

  loadAlerts(): void {
    this.loading = true;
    this.alertService.getAllAlerts().subscribe({
      next: (data) => {
        this.alerts = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Erreur lors du chargement des alertes.';
        this.loading = false;
      }
    });
  }

  loadPatients(): void {
    this.http.get<Patient[]>('http://localhost:8091/api/patients').subscribe({
      next: (data) => {
        data.forEach((patient) => {
          if (patient.id !== undefined) {
            this.patientsMap.set(patient.id, `${patient.firstName} ${patient.lastName}`);
          }
        });
      },
      error: (err) => {
        console.error('Erreur lors du chargement des patients:', err);
      }
    });
  }

  getPatientName(patientId: number): string {
    return this.patientsMap.get(patientId) || 'Non attribué';
  }

  viewDetails(alertId: number): void {
    this.router.navigate(['/alerts', alertId]);
  }

  deleteAlert(id: number): void {
    if (confirm('Voulez-vous vraiment supprimer cette alerte ?')) {
      this.alertService.deleteAlert(id).subscribe(() => this.loadAlerts());
    }
  }
}
