package com.ifsp.edu.sanca_dinner.controller.user.request;

public record LoginRequest(
        String email,
        String password
) {}