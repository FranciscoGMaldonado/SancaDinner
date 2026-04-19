package com.ifsp.edu.sanca_dinner.controller.user;

import com.ifsp.edu.sanca_dinner.controller.user.request.RegisterRequest;
import com.ifsp.edu.sanca_dinner.controller.user.response.AuthResponse;
import com.ifsp.edu.sanca_dinner.controller.user.response.RegisterResponse;
import com.ifsp.edu.sanca_dinner.domain.model.user.User;
import com.ifsp.edu.sanca_dinner.domain.model.user.UserRoles;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public User toEntity(RegisterRequest request, String encodedPassword) {
        UserRoles role = UserRoles.valueOf(request.role().toUpperCase());
        return new User(request.name(), request.email(), encodedPassword, role);
    }

    public RegisterResponse registerToResponse() {
        return new RegisterResponse("Usuário Registrado com Sucesso!");
    }

    public AuthResponse authToResponse(User user, String token) {
        return new AuthResponse(token, user.getName(), user.getRole().name());
    }
}