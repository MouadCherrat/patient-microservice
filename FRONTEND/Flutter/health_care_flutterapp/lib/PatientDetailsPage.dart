import 'package:flutter/material.dart';
import 'ApiService/api-service.dart';

class PatientDetailsPage extends StatefulWidget {
  final String apiUrl;
  final int patientId;

  const PatientDetailsPage({
    Key? key,
    required this.apiUrl,
    required this.patientId,
  }) : super(key: key);

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic>? patientDetails;
  List<dynamic> alerts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetailsAndAlerts();
  }

  void fetchDetailsAndAlerts() async {
    final apiService = ApiService(widget.apiUrl);
    try {
      final details = await apiService.getPatientDetails(widget.patientId);
      final fetchedAlerts =
          await apiService.getAlertsByPatientId(widget.patientId);

      for (var alert in fetchedAlerts) {
        alert['checked'] = alert['checked'] ?? false;
      }

      setState(() {
        patientDetails = details;
        alerts = fetchedAlerts;
        isLoading = false;
      });

      print("Fetched Alerts: $alerts");
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching alerts: $error");
    }
  }

  void updateAlertCheckStatus(int alertId, bool isChecked) async {
    final apiService = ApiService(widget.apiUrl);
    try {
      await apiService.updateAlertCheckStatus(alertId, isChecked);
      setState(() {
        final index = alerts.indexWhere((alert) => alert['id'] == alertId);
        if (index != -1) {
          alerts[index]['checked'] = isChecked;
        }
      });

      print("Updated Alert ID: $alertId to checked: $isChecked");
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating alert status: $error')),
      );
    }
  }

  void showConfirmationDialog(int alertId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Confirm Action"),
          content: Text("Are you sure you want to mark this alert as checked?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                updateAlertCheckStatus(alertId, true);
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Patient Details"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  if (patientDetails != null) ...[
                    Text(
                      "Patient : ${patientDetails!['firstName']} ${patientDetails!['lastName']}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  SizedBox(height: 20),
                  Text(
                    "Alerts:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final alert = alerts[index];
                        final isChecked = alert['checked'] as bool;

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: isChecked
                              ? Colors.white
                              : Colors.red[100], // Red for unchecked alerts
                          child: ListTile(
                            title: Text(
                              alert['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isChecked ? Colors.black : Colors.red,
                              ),
                            ),
                            subtitle: Text(
                              alert['type'],
                              style: TextStyle(
                                fontSize: 14,
                                color: isChecked
                                    ? const Color.fromARGB(255, 186, 0, 0)
                                    : Colors.red[700],
                              ),
                            ),
                            trailing: isChecked
                                ? null
                                : IconButton(
                                    icon: Icon(
                                      Icons.check_box_outline_blank,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    onPressed: () {
                                      showConfirmationDialog(alert['id']);
                                    },
                                  ),
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
