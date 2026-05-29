package com.ifsp.edu.sanca_dinner.application.user.use_cases;

import com.ifsp.edu.sanca_dinner.controller.user.request.LoginRequest;
import com.ifsp.edu.sanca_dinner.controller.user.response.AuthResponse;
import com.ifsp.edu.sanca_dinner.domain.service.auth.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class LoginUseCase {

    private AuthService authService;

    public AuthResponse execute(LoginRequest request){
        return authService.login(request);
    }
}
