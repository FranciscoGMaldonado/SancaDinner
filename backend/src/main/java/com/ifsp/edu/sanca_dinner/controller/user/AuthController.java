package com.ifsp.edu.sanca_dinner.controller.user;

import com.ifsp.edu.sanca_dinner.controller.user.response.AuthResponse;
import com.ifsp.edu.sanca_dinner.controller.user.request.LoginRequest;
import com.ifsp.edu.sanca_dinner.controller.user.request.RegisterRequest;
import com.ifsp.edu.sanca_dinner.controller.user.response.RegisterResponse;
import com.ifsp.edu.sanca_dinner.domain.service.auth.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }
}