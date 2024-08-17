package com.emr.www.exception;

public class PatientValidationException extends RuntimeException {
    private static final long serialVersionUID = 3L;

    public PatientValidationException(String message) {
        super(message);
    }

    public PatientValidationException(String message, Throwable cause) {
        super(message, cause);
    }
}