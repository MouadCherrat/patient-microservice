package com.hps.patientservice.controller;

import com.hps.patientservice.entity.LocationHistory;
import com.hps.patientservice.service.LocationHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/location-history")
@RequiredArgsConstructor
public class LocationHistoryController {

    private final LocationHistoryService locationHistoryService;

    @GetMapping
    public List<LocationHistory> getAllLocationHistories() {
        return locationHistoryService.getAllLocationHistories();
    }

    @GetMapping("/{id}")
    public ResponseEntity<LocationHistory> getLocationHistoryById(@PathVariable Long id) {
        return locationHistoryService.getLocationHistoryById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<LocationHistory> createLocationHistory(@RequestBody LocationHistory locationHistory) {
        return ResponseEntity.ok(locationHistoryService.createLocationHistory(locationHistory));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteLocationHistory(@PathVariable Long id) {
        locationHistoryService.deleteLocationHistory(id);
        return ResponseEntity.noContent().build();
    }
}
