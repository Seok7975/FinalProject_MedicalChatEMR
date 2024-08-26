package com.emr.www.exception;

public class DuplicatePatientException extends RuntimeException {
    private static final long serialVersionUID = 2L;

    public DuplicatePatientException(String message) {
        super(message);
    }

    public DuplicatePatientException(String message, Throwable cause) {
        super(message, cause);
    }
}