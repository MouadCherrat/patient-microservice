import { Component, OnInit } from '@angular/core';
import { AlertService } from 'src/app/services/alert/alert.service';
import { Alert } from 'src/app/models/alert.model';
import { Patient } from 'src/app/models/patient.model'; 
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-alert-create',
  templateUrl: './alert-create.component.html',
  styleUrls: ['./alert-create.component.css']
})
export class AlertCreateComponent implements OnInit {
  alert: Alert = {
    title: '',
    description: '',
    type: 'WARNING',
    patientId: 0 
  };

  patients: Patient[] = []; 

  constructor(
    private alertService: AlertService,
    private http: HttpClient,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadPatients();
  }

  loadPatients(): void {
    // Récupération des patients depuis l'API
    this.http.get<Patient[]>('http://localhost:8091/api/patients').subscribe({
      next: (data) => {
        this.patients = data;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des patients:', err);
      }
    });
  }

  createAlert(): void {
    console.log('Données envoyées :', this.alert);
  
    const patientId = this.alert.patientId; // Récupération du patientId sélectionné
  
    // Vérification si le patientId est bien sélectionné
    if (!patientId) {
      console.error('Patient ID est requis.');
      return;
    }
  
    this.alertService.createAlert(this.alert, patientId).subscribe({
      next: () => {
        console.log('Alerte créée avec succès');
        this.router.navigate(['/alerts']);
      },
      error: (err) => {
        console.error("Erreur lors de la création de l'alerte :", err);
      }
    });
  }
  
}
