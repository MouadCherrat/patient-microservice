import 'package:flutter/material.dart';
import 'Model/data_sender.dart';
import 'ApiService/api-service.dart';

class PatientMonitoring extends StatefulWidget {
  final String apiUrl;
  final int patientId;

  const PatientMonitoring({
    Key? key,
    required this.apiUrl,
    required this.patientId,
  }) : super(key: key);

  @override
  _PatientMonitoringState createState() => _PatientMonitoringState();
}

class _PatientMonitoringState extends State<PatientMonitoring> {
  DataSender? dataSender;
  String? firstName;
  String? lastName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(widget.apiUrl);
    dataSender = DataSender(
      apiService: apiService,
      patientId: widget.patientId,
      context: context,
    );
    fetchPatientDetails(apiService);
  }

  void fetchPatientDetails(ApiService apiService) async {
    try {
      final patientDetails =
          await apiService.getPatientDetails(widget.patientId);
      setState(() {
        firstName = patientDetails['firstName'];
        lastName = patientDetails['lastName'];
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch patient details')),
      );
    }
  }

  void startMonitoring() {
    dataSender?.startSending();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Monitoring started for Patient ID ${widget.patientId}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Patient Monitoring'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (firstName != null && lastName != null)
                    Text(
                      'Welcome, $firstName $lastName',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  SizedBox(height: 20),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: startMonitoring,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Monitoring',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
