import 'package:flutter/material.dart';
import 'ApiService/api-service.dart';
import 'PatientDetailsPage.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  late String apiUrl;
  late int doctorId;
  bool isLoading = true;
  List<dynamic> patients = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args == null || args['apiUrl'] == null || args['doctorId'] == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    apiUrl = args['apiUrl'];
    doctorId = args['doctorId'];
    fetchPatients();
  }

  void fetchPatients() async {
    final apiService = ApiService(apiUrl);
    try {
      final fetchedPatients = await apiService.getPatientsByDoctor(doctorId);
      setState(() {
        patients = fetchedPatients;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching patients: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToPatientDetails(int patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsPage(
          apiUrl: apiUrl,
          patientId: patientId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Doctor Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : patients.isEmpty
              ? Center(
                  child: Text(
                    "No patients found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Patients List:",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 0),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  "${patient['firstName']} ${patient['lastName']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "Address: ${patient['address']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blue,
                                ),
                                onTap: () =>
                                    navigateToPatientDetails(patient['id']),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
