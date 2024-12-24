package com.hps.alertservice.controller;

import com.hps.alertservice.entity.Alert;
import com.hps.alertservice.service.AlertService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/alerts")
@RequiredArgsConstructor
public class AlertController {
    private final AlertService alertService;
    @GetMapping
    public List<Alert> getAllAlerts() {
        return alertService.getAllAlerts();
    }
    @GetMapping("/{id}")
    public ResponseEntity<Alert> getAlertById(@PathVariable Long id) {
        return alertService.getAlertById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Alert> createAlert(@RequestBody Alert alert) {
        try {
            if (alert.getPatientId() == null) {
                return ResponseEntity.badRequest().body(null);
            }
            Alert createdAlert = alertService.createAlert(alert, alert.getPatientId());
            return ResponseEntity.status(HttpStatus.CREATED).body(createdAlert);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @PutMapping("/{id}/check")
    public ResponseEntity<Alert> markAlertAsChecked(@PathVariable Long id) {
        Optional<Alert> updatedAlert = alertService.markAlertAsChecked(id);
        return updatedAlert.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }




    @PutMapping("/{id}")
    public ResponseEntity<Alert> updateAlert(@PathVariable Long id, @RequestBody Alert alertDetails) {
        try {
            return ResponseEntity.ok(alertService.updateAlert(id, alertDetails));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAlert(@PathVariable Long id) {
        alertService.deleteAlert(id);
        return ResponseEntity.noContent().build();
    }
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<Alert>> getAlertsByPatientId(@PathVariable Long patientId) {
        List<Alert> alerts = alertService.getAlertsByPatientId(patientId);
        return ResponseEntity.ok(alerts);
    }

}
