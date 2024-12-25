import { Component, OnInit } from '@angular/core';
import { AlertService } from 'src/app/services/alert/alert.service';
import { Alert } from 'src/app/models/alert.model';
import { HttpClient } from '@angular/common/http';
import { Patient } from 'src/app/models/patient.model';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-alert-detail',
  templateUrl: './alert-detail.component.html',
  styleUrls: ['./alert-detail.component.css']
})
export class AlertDetailComponent implements OnInit {
  alert: Alert | undefined;
  patient: Patient | undefined; // Pour stocker les détails du patient
  loading: boolean = true;
  error: string | null = null;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private alertService: AlertService,
    private http: HttpClient
  ) {}

  ngOnInit(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    if (isNaN(id)) {
      this.error = "ID invalide.";
      this.loading = false;
      return;
    }

    this.alertService.getAlertById(id).subscribe({
      next: (data) => {
        this.alert = data;
        if (this.alert.patientId) {
          this.loadPatientDetails(this.alert.patientId);
        }
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Alerte introuvable ou une erreur est survenue.';
        console.error(err);
        this.loading = false;
      }
    });
  }

  loadPatientDetails(patientId: number): void {
    this.http.get<Patient>(`http://localhost:8091/api/patients/${patientId}`).subscribe({
      next: (data) => {
        this.patient = data;
      },
      error: (err) => {
        console.error("Erreur lors du chargement des détails du patient :", err);
      }
    });
  }

  goBack(): void {
    this.router.navigate(['/alerts']);
  }
}
