package com.ifsp.edu.sanca_dinner.infrastructure.persistance.user;

import com.ifsp.edu.sanca_dinner.domain.model.user.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JpaUserRepository extends JpaRepository<User, Integer> {}
