package com.hps.patientservice.controller;

import com.hps.patientservice.entity.Patient;
import com.hps.patientservice.entity.PatientData;
import com.hps.patientservice.http.PredictionServiceClient;
import com.hps.patientservice.service.PatientService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/patients")
@RequiredArgsConstructor
public class PatientController {

    private final PredictionServiceClient predictionServiceClient;
    private final PatientService patientService;

    @PostMapping("/predict")
    public Map<String, Object> predictBehavior(@RequestBody PatientData patientData) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("sequence", patientData.getSequence());
        Map<String, Object> predictionResponse = predictionServiceClient.getPrediction(payload);
        predictionResponse.put("patientId", patientData.getPatientId());
        return predictionResponse;
    }

    @GetMapping
    public List<Patient> getAllPatients() {
        return patientService.getAllPatients();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Patient> getPatientById(@PathVariable Long id) {
        return patientService.getPatientById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Patient> createPatient(@RequestBody Patient patient) {
        return ResponseEntity.ok(patientService.createPatient(patient));
    }
    @GetMapping("/by-doctor")
    public ResponseEntity<List<Patient>> getPatientsByDoctor(@RequestParam Long doctorId) {
        List<Patient> patients = patientService.getPatientsByDoctor(doctorId);
        return ResponseEntity.ok(patients);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Patient> updatePatient(@PathVariable Long id, @RequestBody Patient patientDetails) {
        try {
            return ResponseEntity.ok(patientService.updatePatient(id, patientDetails));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePatient(@PathVariable Long id) {
        patientService.deletePatient(id);
        return ResponseEntity.noContent().build();
    }
    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody Map<String, String> loginRequest) {
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        // Validate username and password
        Optional<Patient> patient = patientService.getPatientByUsernameAndPassword(username, password);
        if (patient.isPresent()) {
            Map<String, String> response = new HashMap<>();
            response.put("message", "Login successful");
            response.put("patientId", patient.get().getId().toString());
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(401).body(Map.of("message", "Invalid username or password"));
        }
    }

}
