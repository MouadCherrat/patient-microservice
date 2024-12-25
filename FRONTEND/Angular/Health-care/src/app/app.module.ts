import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

// Composants principaux
import { AppComponent } from './app.component';

// Modules de routage
import { AppRoutingModule } from './app-routing.module';

// Composants Alertes
import { AlertListComponent } from './components/alert-list/alert-list.component';
import { AlertDetailComponent } from './components/alert-detail/alert-detail.component';
import { AlertCreateComponent } from './components/alert-create/alert-create.component';

// Composants Utilisateurs
import { UserListComponent } from './components/user-list/user-list.component';
import { UserFormComponent } from './components/user-form/user-form.component';
import { UserDetailsComponent } from './components/user-details/user-details.component';
import { DoctorPatientsComponent } from './components/doctor-patients/doctor-patients.component';
import { PatientListComponent } from './components/patient-list/patient-list.component';
import { PatientFormComponent } from './components/patient-form/patient-form.component';
import { AdminDashboardComponent } from './components/admin-dashboard/admin-dashboard.component';
import { NavbarComponent } from './components/navbar/navbar.component';

@NgModule({
  declarations: [
    AppComponent,
    AlertListComponent,
    AlertDetailComponent,
    AlertCreateComponent,
    UserListComponent,
    UserFormComponent,
    UserDetailsComponent,
    DoctorPatientsComponent,
    PatientFormComponent,
    PatientFormComponent,
    AdminDashboardComponent,
    NavbarComponent,
  ],
  imports: [
    BrowserModule, // Importé uniquement ici
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
