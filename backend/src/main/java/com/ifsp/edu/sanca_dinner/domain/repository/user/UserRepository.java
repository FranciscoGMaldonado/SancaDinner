package com.ifsp.edu.sanca_dinner.domain.repository.user;

import com.ifsp.edu.sanca_dinner.domain.model.user.User;

import java.util.List;
import java.util.Optional;

public interface UserRepository {
    User save(User user);
    Optional<User> findById(Integer id);
    Optional<User> findByEmail(String email);
    List<User> findAll();
    boolean existsByEmail(String email);
}
