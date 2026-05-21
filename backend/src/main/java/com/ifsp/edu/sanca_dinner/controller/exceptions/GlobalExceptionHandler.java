package com.ifsp.edu.sanca_dinner.controller.exceptions;

import com.ifsp.edu.sanca_dinner.controller.exceptions.response.ErrorResponse;
import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DomainException.class)
    public ResponseEntity<ErrorResponse> domainExceptionHandler(DomainException exception){
        var error = new ErrorResponse(
                exception.getMessage(),
                System.currentTimeMillis());
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
}
