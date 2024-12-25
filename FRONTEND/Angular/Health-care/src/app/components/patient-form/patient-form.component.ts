import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Patient } from 'src/app/models/patient.model';
import { PatientService } from 'src/app/services/patient/patient.service';
import { UserService } from 'src/app/services/user/user.service';

@Component({
  selector: 'app-patient-form',
  templateUrl: './patient-form.component.html',
  styleUrls: ['./patient-form.component.css'],
})
export class PatientFormComponent implements OnInit {
  patient: Patient = {
    firstName: '',
    lastName: '',
    birthDate: '',
    gender: '',
    address: '',
    contactPerson: '',
    contactPhone: '',
    username: '',
    password: '',
    doctorId: undefined,
  };

  doctors: { id: number; name: string }[] = []; // Adjusted structure to use `username`
  isEditMode = false;
  isLoadingDoctors = true;

  constructor(
    private patientService: PatientService,
    private doctorService: UserService,
    private route: ActivatedRoute,
    public router: Router
  ) {}

  ngOnInit(): void {
    this.loadDoctors();
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.patientService.getById(+id).subscribe({
        next: (data) => {
          this.patient = data;
        },
        error: (err) => {
          console.error('Failed to load patient:', err);
          alert('Erreur lors du chargement des données du patient.');
        },
      });
    }
  }

  loadDoctors(): void {
    this.doctorService.getAllUsers().subscribe({
      next: (data: any[]) => {
        console.log('Doctor data:', data);
        this.doctors = data.map((doctor) => ({
          id: doctor.id,
          name: doctor.username, // Use `username` as the doctor name
        }));
        this.isLoadingDoctors = false;
      },
      error: (err) => {
        console.error('Failed to load doctors:', err);
        alert('Erreur lors du chargement des médecins.');
        this.isLoadingDoctors = false;
      },
    });
  }

  onSubmit(): void {
    if (this.isEditMode) {
      this.patientService.update(this.patient.id!, this.patient).subscribe({
        next: () => {
          alert('Patient modifié avec succès.');
          this.router.navigate(['/patients']);
        },
        error: (err) => {
          console.error('Failed to update patient:', err);
          alert('Erreur lors de la modification du patient.');
        },
      });
    } else {
      this.patientService.create(this.patient).subscribe({
        next: () => {
          alert('Patient créé avec succès.');
          this.router.navigate(['/patients']);
        },
        error: (err) => {
          console.error('Failed to create patient:', err);
          alert('Erreur lors de la création du patient.');
        },
      });
    }
  }
}
