import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { Patient } from 'src/app/models/patient.model';
import { PatientService } from 'src/app/services/patient/patient.service';
import { UserService } from 'src/app/services/user/user.service';

@Component({
  selector: 'app-patient-list',
  standalone: true,
  imports: [CommonModule, RouterModule], // Include CommonModule for ngFor
  templateUrl: './patient-list.component.html',
  styleUrls: ['./patient-list.component.css'],
})
export class PatientListComponent implements OnInit {
  patients: Patient[] = []; // List of patients
  doctorsNameCache: Map<number, string> = new Map(); // Cache to store doctor names

  constructor(
    private patientService: PatientService,
    private userService: UserService, // For retrieving doctor details
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadPatients(); // Load patients
  }

  // Fetch all patients
  loadPatients(): void {
    this.patientService.getAll().subscribe({
      next: (data) => {
        this.patients = data;
      },
      error: (err) => {
        console.error('Failed to load patients:', err);
        alert('Une erreur est survenue lors du chargement des patients.');
      },
    });
  }

  // Get the doctor's name by their ID
  getDoctorName(doctorId: number | undefined): string {
    if (!doctorId) {
      return 'Non attribué';
    }

    // Check if the doctor's name is already cached
    if (this.doctorsNameCache.has(doctorId)) {
      return this.doctorsNameCache.get(doctorId)!;
    }

    // If not cached, fetch the doctor's name
    this.userService.getUserById(doctorId).subscribe({
      next: (doctor) => {
        this.doctorsNameCache.set(doctorId, doctor.username); // Cache the doctor's name
      },
      error: () => {
        this.doctorsNameCache.set(doctorId, 'Non attribué'); // Cache a default value if error occurs
      },
    });

    return 'Chargement...'; // Return a placeholder while the name is being fetched
  }

  // Delete a patient and refresh the list
  deletePatient(id: number): void {
    if (confirm('Voulez-vous vraiment supprimer ce patient ?')) {
      this.patientService.delete(id).subscribe({
        next: () => {
          this.loadPatients();
        },
        error: (err) => {
          console.error('Failed to delete patient:', err);
          alert('Une erreur est survenue lors de la suppression du patient.');
        },
      });
    }
  }

  // Navigate to the add patient page
  addPatient(): void {
    this.router.navigate(['/patients/add']);
  }

  // Navigate to the edit patient page
  editPatient(id: number): void {
    this.router.navigate([`/patients/edit/${id}`]);
  }
}
