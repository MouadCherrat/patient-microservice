package com.hps.patientservice.service;

import com.hps.patientservice.entity.MedicalRecord;
import com.hps.patientservice.repository.MedicalRecordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MedicalRecordService {

    private final MedicalRecordRepository medicalRecordRepository;

    public List<MedicalRecord> getAllMedicalRecords() {
        return medicalRecordRepository.findAll();
    }

    public Optional<MedicalRecord> getMedicalRecordById(Long id) {
        return medicalRecordRepository.findById(id);
    }

    public MedicalRecord createMedicalRecord(MedicalRecord medicalRecord) {
        return medicalRecordRepository.save(medicalRecord);
    }

    public MedicalRecord updateMedicalRecord(Long id, MedicalRecord recordDetails) {
        return medicalRecordRepository.findById(id).map(record -> {
            record.setDiagnosis(recordDetails.getDiagnosis());
            record.setTreatmentPlan(recordDetails.getTreatmentPlan());
            return medicalRecordRepository.save(record);
        }).orElseThrow(() -> new RuntimeException("MedicalRecord not found"));
    }

    public void deleteMedicalRecord(Long id) {
        medicalRecordRepository.deleteById(id);
    }
}
