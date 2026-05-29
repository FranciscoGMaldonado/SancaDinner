package com.ifsp.edu.sanca_dinner.application.user.use_cases;

import com.ifsp.edu.sanca_dinner.controller.user.request.RegisterRequest;
import com.ifsp.edu.sanca_dinner.controller.user.response.RegisterResponse;
import com.ifsp.edu.sanca_dinner.domain.service.auth.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class RegisterUserUseCase {

    private AuthService authService;

    public RegisterResponse execute(RegisterRequest request){
        return authService.register(request);
    }
}
