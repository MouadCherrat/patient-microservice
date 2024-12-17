package com.hps.alertservice.http;

import com.hps.alertservice.dto.PatientResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "patient-service", url = "http://localhost:8091/api/patients") // URL du Patient-Service
public interface PatientClient {

    @GetMapping("/{id}")
    PatientResponse getPatientById(@PathVariable Long id);

}
