package com.emr.www.exception;

public class PatientServiceException extends RuntimeException {
    private static final long serialVersionUID = 4L;

    public PatientServiceException(String message) {
        super(message);
    }

    public PatientServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}