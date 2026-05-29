package com.ifsp.edu.sanca_dinner.controller.user;

import com.ifsp.edu.sanca_dinner.application.user.use_cases.GetAllUsersUseCase;
import com.ifsp.edu.sanca_dinner.controller.user.response.UserResponse;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@AllArgsConstructor
public class UserController {

    private GetAllUsersUseCase getAllUsersUseCase;

    @GetMapping
    public ResponseEntity<List<UserResponse>> getAllUsers(){
        return ResponseEntity.ok(getAllUsersUseCase.execute());
    }
}
