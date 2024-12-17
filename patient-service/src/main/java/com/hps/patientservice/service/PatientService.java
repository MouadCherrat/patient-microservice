package com.hps.patientservice.service;

import com.hps.patientservice.entity.Patient;
import com.hps.patientservice.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PatientService {

    private final PatientRepository patientRepository;

    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }

    public Patient createPatient(Patient patient) {
        return patientRepository.save(patient);
    }

    public Patient updatePatient(Long id, Patient patientDetails) {
        return patientRepository.findById(id).map(patient -> {
            patient.setFirstName(patientDetails.getFirstName());
            patient.setLastName(patientDetails.getLastName());
            patient.setBirthDate(patientDetails.getBirthDate());
            patient.setGender(patientDetails.getGender());
            patient.setAddress(patientDetails.getAddress());
            patient.setContactPerson(patientDetails.getContactPerson());
            patient.setContactPhone(patientDetails.getContactPhone());
            return patientRepository.save(patient);
        }).orElseThrow(() -> new RuntimeException("Patient not found"));
    }
    public List<Patient> getPatientsByDoctor(Long doctorId) {
        return patientRepository.findByDoctorId(doctorId);
    }

    public void deletePatient(Long id) {
        patientRepository.deleteById(id);
    }
}
