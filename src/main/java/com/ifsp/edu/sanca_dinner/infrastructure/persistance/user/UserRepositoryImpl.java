package com.ifsp.edu.sanca_dinner.infrastructure.persistance.user;

import com.ifsp.edu.sanca_dinner.domain.model.user.User;
import com.ifsp.edu.sanca_dinner.domain.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
public class UserRepositoryImpl implements UserRepository {

    private final JpaUserRepository jpaRepository;

    @Override
    public User save(User user) { return jpaRepository.save(user); }

    @Override
    public Optional<User> findById(Integer id) { return jpaRepository.findById(id); }

    @Override
    public Optional<User> findByEmail(String email) { return jpaRepository.findByEmail(email); }

    @Override
    public boolean existsByEmail(String email) { return jpaRepository.existsByEmail(email); }
}
