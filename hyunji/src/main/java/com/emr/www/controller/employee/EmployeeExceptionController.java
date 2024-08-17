package com.emr.www.controller.employee;

import java.util.HashMap;
import java.util.Map;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import com.emr.www.controller.employee.exception.LicenseKeyNotFoundException;

@ControllerAdvice
public class EmployeeExceptionController {

	  @ExceptionHandler(DuplicateKeyException.class)
	    @ResponseBody
	    public ResponseEntity<Map<String, String>> handleDuplicateKeyException(DuplicateKeyException ex) {
	        Map<String, String> errorResponse = new HashMap<>();
	        errorResponse.put("message", "Duplicate Key Error");
	        return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResponse);
	    }

	    @ExceptionHandler(LicenseKeyNotFoundException.class)
	    @ResponseBody
	    public ResponseEntity<Map<String, String>> handleLicenseKeyNotFoundException(LicenseKeyNotFoundException ex) {
	        Map<String, String> errorResponse = new HashMap<>();
	        errorResponse.put("message", ex.getMessage());
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
	    }

	    @ExceptionHandler(Exception.class)
	    @ResponseBody
	    public ResponseEntity<Map<String, String>> handleException(Exception ex) {
	        Map<String, String> errorResponse = new HashMap<>();
	        errorResponse.put("message", "An error occurred");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
	    }

}
