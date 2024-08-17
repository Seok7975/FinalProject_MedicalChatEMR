package com.study.springboot;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DuplicateKeyException.class)
    @ResponseBody
    public ResponseEntity<Map<String, String>> handleDuplicateKeyException(DuplicateKeyException ex) {
        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put("message", "already License Key exist");
        return ResponseEntity.status(HttpStatus.CONFLICT).body(errorResponse);
    }
    
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public ResponseEntity<Map<String, String>> handleException(Exception ex) {
        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put("message", "An error occurred");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
    }
}
