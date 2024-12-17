package com.hps.alertservice.controller;

import com.hps.alertservice.entity.Alert;
import com.hps.alertservice.service.AlertService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
    public ResponseEntity<Alert> createAlert(
            @RequestBody Alert alert,
            @RequestParam Long patientId) {
        try {
            Alert createdAlert = alertService.createAlert(alert, patientId);
            return ResponseEntity.ok(createdAlert);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(404).body(null);
        }
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
}
