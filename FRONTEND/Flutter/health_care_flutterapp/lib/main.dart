import 'package:flutter/material.dart';
import 'doctor_dashboard.dart';
import 'patient_login.dart';
import 'user_selection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Selection App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserSelection(),
      routes: {
        '/patient-login': (context) => PatientLogin(),
        '/doctor-dashboard': (context) => DoctorDashboard(),
      },
    );
  }
}
