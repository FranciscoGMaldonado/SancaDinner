package com.ifsp.edu.sanca_dinner.domain.service;

import com.ifsp.edu.sanca_dinner.controller.user.UserMapper;
import com.ifsp.edu.sanca_dinner.controller.user.request.LoginRequest;
import com.ifsp.edu.sanca_dinner.controller.user.request.RegisterRequest;
import com.ifsp.edu.sanca_dinner.controller.user.response.AuthResponse;
import com.ifsp.edu.sanca_dinner.controller.user.response.RegisterResponse;
import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import com.ifsp.edu.sanca_dinner.domain.model.user.User;
import com.ifsp.edu.sanca_dinner.domain.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final UserMapper userMapper;

    public RegisterResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new DomainException("Email já cadastrado.");
        }
        String encodedPassword = passwordEncoder.encode(request.password());
        userRepository.save(userMapper.toEntity(request, encodedPassword));
        return userMapper.registerToResponse();
    }

    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new DomainException("Email ou Senha Inválidos."));

        if (!passwordEncoder.matches(request.password(), user.getPassword())) {
            throw new DomainException("Email ou Senha Inválidos.");
        }

        String token = jwtService.generateToken(user.getEmail(), user.getRole().name());
        return userMapper.authToResponse(user, token);
    }
}
