package com.ifsp.edu.sanca_dinner.application.user.use_cases;

import com.ifsp.edu.sanca_dinner.application.user.mapper.UserMapper;
import com.ifsp.edu.sanca_dinner.controller.user.response.UserResponse;
import com.ifsp.edu.sanca_dinner.domain.service.auth.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@AllArgsConstructor
public class GetAllUsersUseCase {
    
    private AuthService authService;
    private UserMapper userMapper;

    public List<UserResponse> execute(){
        return authService.findAllUsers().stream().
                map(userMapper::userToResponse).
                toList();
    }
}
