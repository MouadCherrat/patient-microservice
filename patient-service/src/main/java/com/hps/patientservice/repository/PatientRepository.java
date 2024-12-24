package com.hps.patientservice.repository;

import com.hps.patientservice.entity.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {
    List<Patient> findByDoctorId(Long doctorId);
    Optional<Patient> findByUsernameAndPassword(String username, String password);


}
