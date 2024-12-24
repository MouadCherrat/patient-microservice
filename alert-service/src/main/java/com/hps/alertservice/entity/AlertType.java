package com.hps.alertservice.entity;

public enum AlertType {
    RISQUE_DE_CHUTE,         // Falling
    SORTIE_NON_AUTORISER,    // Unauthorized exit
    COMPORTEMENT_ANORMALE,   // Abnormal behavior
    NOT_MOVING               // Idle
}
