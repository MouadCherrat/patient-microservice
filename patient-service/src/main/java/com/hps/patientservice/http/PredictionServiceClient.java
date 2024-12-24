package com.hps.patientservice.http;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import java.util.Map;

@FeignClient(name = "model-service",url = "http://localhost:5000")
public interface PredictionServiceClient {
    @PostMapping("/predict")
    Map<String, Object> getPrediction(@RequestBody Map<String, Object> request);
}
