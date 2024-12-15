package com.hps.patientservice.service;

import com.hps.patientservice.entity.LocationHistory;
import com.hps.patientservice.repository.LocationHistoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class LocationHistoryService {

    private final LocationHistoryRepository locationHistoryRepository;

    public List<LocationHistory> getAllLocationHistories() {
        return locationHistoryRepository.findAll();
    }

    public Optional<LocationHistory> getLocationHistoryById(Long id) {
        return locationHistoryRepository.findById(id);
    }

    public LocationHistory createLocationHistory(LocationHistory locationHistory) {
        return locationHistoryRepository.save(locationHistory);
    }

    public void deleteLocationHistory(Long id) {
        locationHistoryRepository.deleteById(id);
    }
}
