package com.hps.alertservice.repository;

import com.hps.alertservice.entity.Alert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AlertRepository extends JpaRepository<Alert, Long> {
    List<Alert> findByPatientIdOrderByCreatedAtDesc(Long patientId);
}
