package com.ifsp.edu.sanca_dinner.controller.user.response;

import com.ifsp.edu.sanca_dinner.domain.model.user.UserRoles;

public record UserResponse(
        Integer id,
        String name,
        String email,
        UserRoles role
) {}
