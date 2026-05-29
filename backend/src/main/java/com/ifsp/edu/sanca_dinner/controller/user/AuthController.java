package com.ifsp.edu.sanca_dinner.controller.user;

import com.ifsp.edu.sanca_dinner.application.user.use_cases.LoginUseCase;
import com.ifsp.edu.sanca_dinner.application.user.use_cases.RegisterUserUseCase;
import com.ifsp.edu.sanca_dinner.controller.user.response.AuthResponse;
import com.ifsp.edu.sanca_dinner.controller.user.request.LoginRequest;
import com.ifsp.edu.sanca_dinner.controller.user.request.RegisterRequest;
import com.ifsp.edu.sanca_dinner.controller.user.response.RegisterResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@AllArgsConstructor
public class AuthController {

    private RegisterUserUseCase registerUserUseCase;
    private LoginUseCase loginUseCase;

    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(registerUserUseCase.execute(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(loginUseCase.execute(request));
    }
}