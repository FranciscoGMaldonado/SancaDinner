package com.ifsp.edu.sanca_dinner.controller.user.request;

public record RegisterRequest(
        String name,
        String email,
        String password,
        String role
) {}