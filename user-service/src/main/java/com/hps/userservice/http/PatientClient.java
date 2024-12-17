package com.hps.userservice.http;

import com.hps.userservice.dto.PatientResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@FeignClient(name = "patient-service", url = "http://localhost:8091/api/patients")
public interface PatientClient {

    @GetMapping("/by-doctor")
    List<PatientResponse> getPatientsByDoctor(@RequestParam Long doctorId);
}
