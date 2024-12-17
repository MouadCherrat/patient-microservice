package com.hps.alertservice.dto;


import lombok.Data;

@Data
public class PatientResponse {
    private Long id;
    private String firstName;
    private String lastName;
    private String address;
    private String contactPerson;
    private String contactPhone;
}

