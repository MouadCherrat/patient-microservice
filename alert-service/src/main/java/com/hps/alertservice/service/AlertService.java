package com.hps.alertservice.service;

import com.hps.alertservice.entity.Alert;
import com.hps.alertservice.repository.AlertRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AlertService {

    private final AlertRepository alertRepository;

    public List<Alert> getAllAlerts() {
        return alertRepository.findAll();
    }

    public Optional<Alert> getAlertById(Long id) {
        return alertRepository.findById(id);
    }

    public Alert createAlert(Alert alert) {
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
