import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  /// Login Method
  Future<Map<String, dynamic>> loginPatient(
      String username, String password) async {
    final url = Uri.parse('$baseUrl/api/patients/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(
          response.body); // Returns a map with 'patientId' and 'message'
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  /// Fetch Patient Details
  Future<Map<String, dynamic>> getPatientDetails(int patientId) async {
    final url = Uri.parse('$baseUrl/api/patients/$patientId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch patient details: ${response.body}');
    }
  }

  /// Predict Patient Behavior
  Future<Map<String, dynamic>> predictBehavior(
      int patientId, List<List<List<double>>> sequence) async {
    final url = Uri.parse('$baseUrl/api/patients/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "patientId": patientId,
        "sequence": sequence,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get prediction: ${response.body}');
    }
  }

  /// Save Alert to Database
  Future<void> saveAlertToDatabase({
    required int patientId,
    required String title,
    required String description,
    required String type,
  }) async {
    final url = Uri.parse('$baseUrl/api/alerts');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "type": type,
          "patientId": patientId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Alert saved successfully: ${response.body}");
      } else {
        print("Failed to save alert: ${response.body}");
      }
    } catch (error) {
      print("Error saving alert: $error");
    }
  }

  /// Get Patients by Doctor ID
  Future<List<dynamic>> getPatientsByDoctor(int doctorId) async {
    final url = Uri.parse('$baseUrl/api/users/$doctorId/patients');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch patients: ${response.body}');
    }
  }

  Future<List<dynamic>> getAlertsByPatientId(int patientId) async {
    final url = Uri.parse('$baseUrl/api/alerts/patient/$patientId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch alerts: ${response.body}');
    }
  }

  Future<void> updateAlertCheckStatus(int alertId, bool isChecked) async {
    final url = Uri.parse('$baseUrl/api/alerts/$alertId/check');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"isChecked": isChecked}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update alert check status: ${response.body}');
    }
  }
}
