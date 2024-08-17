package com.emr.www.exception;

public class EmrSystemException extends RuntimeException {
    private static final long serialVersionUID = 5L;

    public EmrSystemException(String message) {
        super(message);
    }

    public EmrSystemException(String message, Throwable cause) {
        super(message, cause);
    }
}