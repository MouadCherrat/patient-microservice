import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-admin-dashboard',
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.css']
})
export class AdminDashboardComponent {
  constructor(private router: Router) {}

  navigateToAddDoctor(): void {
    this.router.navigate(['/add-user']); // Assuming '/add-user' is the route for adding doctors
  }

  navigateToAddPatient(): void {
    this.router.navigate(['/patients/add']); // Assuming '/patients/add' is the route for adding patients
  }
}
