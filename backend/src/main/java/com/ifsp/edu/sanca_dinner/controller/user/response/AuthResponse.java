package com.ifsp.edu.sanca_dinner.controller.user.response;

public record AuthResponse(
        String token,
        String name,
        String role
) {}