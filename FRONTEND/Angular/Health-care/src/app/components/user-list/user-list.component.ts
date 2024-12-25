import { Component, OnInit } from '@angular/core';
import { User } from '../../models/user.model';
import { Router } from '@angular/router';
import { UserService } from 'src/app/services/user/user.service';

@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.css'],
})
export class UserListComponent implements OnInit {
  users: User[] = []; // List of users

  constructor(private userService: UserService, private router: Router) {}

  ngOnInit(): void {
    this.fetchDoctors(); // Fetch doctors on component load
  }

  // Fetch only users with the DOCTOR role
  fetchDoctors(): void {
    this.userService.getAllUsers().subscribe((data) => {
      this.users = data.filter((user) => user.role === 'DOCTOR');
    });
  }

  // Navigate to user details page
  navigateToDetails(userId: number | undefined): void {
    if (userId) {
      this.router.navigate(['/user-details', userId]); // Redirect to user details route
    } else {
      console.error('Invalid user ID');
    }
  }

  // Delete a user and refresh the list
  deleteUser(id: number): void {
    if (confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
      this.userService.deleteUser(id).subscribe(() => {
        this.fetchDoctors();
      });
    }
  }
}
