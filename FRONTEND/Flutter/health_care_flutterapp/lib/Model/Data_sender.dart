import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../ApiService/api-service.dart';

class DataSender {
  final ApiService apiService;
  final int patientId;
  final BuildContext context;

  bool _shouldStop = false;

  DataSender({
    required this.apiService,
    required this.patientId,
    required this.context,
  });

  void startSending() {
    _shouldStop = false; // Reset the flag when monitoring starts
    Timer.periodic(Duration(seconds: 10), (timer) async {
      if (_shouldStop) {
        timer.cancel(); // Stop the timer if _shouldStop is true
        return;
      }

      try {
        List<List<double>> sequence = await collectRealTimeLocationData();
        if (sequence.length == 10) {
          print('Generated Sequence: $sequence');
          final response =
              await apiService.predictBehavior(patientId, [sequence]);
          handlePrediction(response);
        } else {
          print('Failed to collect 10 locations in time.');
        }
      } catch (error) {
        print('Error sending data: $error');
      }
    });
  }

  Future<List<List<double>>> collectRealTimeLocationData() async {
    List<List<double>> sequence = [];
    for (int i = 0; i < 10; i++) {
      if (_shouldStop) break; // Stop collecting data if _shouldStop is true

      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception('Location permissions are denied.');
          }
        }
        if (permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are permanently denied.');
        }
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        sequence
            .add([position.latitude, position.longitude, position.altitude]);

        print(
            'Collected location: ${position.latitude}, ${position.longitude}, ${position.altitude}');
      } catch (error) {
        print('Error collecting location: $error');
      }
      await Future.delayed(Duration(seconds: 1));
    }
    return sequence;
  }

  void handlePrediction(Map<String, dynamic> response) {
    final predictedLabel =
        response['predicted_label'].toString().trim().toLowerCase();
    String? alertType;

    // Map predicted labels to alert types
    if (predictedLabel == "falling") {
      alertType = "RISQUE_DE_CHUTE";
    } else if (predictedLabel == "running" || predictedLabel == "walking") {
      alertType = "COMPORTEMENT_ANORMALE";
    }

    // If alertType is identified, save it to the database and stop further predictions
    if (alertType != null) {
      print(
        'Prediction Result:\n'
        'Patient ID: ${response['patientId']}\n'
        'Predicted Label: $predictedLabel\n'
        'Alert Type: $alertType',
      );
      apiService.saveAlertToDatabase(
        patientId: patientId,
        title: "Behavior Alert",
        description: "Patient behavior detected: $predictedLabel",
        type: alertType,
      );

      // Stop further sequence generation after the first relevant prediction
      _shouldStop = true;
    } else {
      print(
          'Prediction: $predictedLabel. No alert generated for idle or unsupported label.');
    }
  }
}
