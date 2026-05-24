package com.ifsp.edu.sanca_dinner.controller.exceptions.response;

public record ErrorResponse(
        String message,
        Long timeStamp
) {}
