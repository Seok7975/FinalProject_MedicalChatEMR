package com.emr.www.controller.employee.exception;


public class LicenseKeyNotFoundException extends RuntimeException {
    public LicenseKeyNotFoundException(String message) {
        super(message);
    }
}