package com.hps.alertservice.service;

import com.hps.alertservice.dto.PatientResponse;
import com.hps.alertservice.entity.Alert;
import com.hps.alertservice.http.PatientClient;
import com.hps.alertservice.repository.AlertRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AlertService {

    private final AlertRepository alertRepository;
    private final PatientClient patientClient;


    public List<Alert> getAllAlerts() {
        return alertRepository.findAll();
    }

    public Optional<Alert> getAlertById(Long id) {
        return alertRepository.findById(id);
    }

    public Alert createAlert(Alert alert, Long patientId) {
        PatientResponse patient = patientClient.getPatientById(patientId);
        if (patient == null) {
            throw new IllegalArgumentException("Patient not found with ID: " + patientId);
        }

        System.out.println("Patient Details: " + patient);

        return alertRepository.save(alert);
    }

    public Alert updateAlert(Long id, Alert alertDetails) {
        return alertRepository.findById(id).map(alert -> {
            alert.setTitle(alertDetails.getTitle());
            alert.setDescription(alertDetails.getDescription());
            alert.setType(alertDetails.getType());
            return alertRepository.save(alert);
        }).orElseThrow(() -> new RuntimeException("Alert not found"));
    }

    public void deleteAlert(Long id) {
        alertRepository.deleteById(id);
    }
}
