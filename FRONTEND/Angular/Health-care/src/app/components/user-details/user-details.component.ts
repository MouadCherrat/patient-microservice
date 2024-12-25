import { Component, OnInit } from '@angular/core';
import { User } from '../../models/user.model';
import { ActivatedRoute, Router } from '@angular/router';
import { UserService } from 'src/app/services/user/user.service';

@Component({
  selector: 'app-user-details',
  templateUrl: './user-details.component.html',
  styleUrls: ['./user-details.component.css']
})
export class UserDetailsComponent implements OnInit {
  user!: User;

  constructor(
    private route: ActivatedRoute,
    private userService: UserService,
    private router: Router
  ) {}

  ngOnInit(): void {
    const id = +this.route.snapshot.paramMap.get('id')!;
    this.userService.getUserById(id).subscribe((data) => {
      this.user = data;
    });
  }

  // Naviguer vers la page de modification
  navigateToEdit(): void {
    if (this.user?.id) {
      this.router.navigate(['/edit-user', this.user.id]);
    } else {
      console.error('ID utilisateur non valide');
    }
  }
}
