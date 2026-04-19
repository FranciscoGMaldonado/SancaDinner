package com.ifsp.edu.sanca_dinner.domain.repository;

import com.ifsp.edu.sanca_dinner.domain.model.user.User;

import java.util.Optional;

public interface UserRepository {
    User save(User user);
    Optional<User> findById(Integer id);
}
