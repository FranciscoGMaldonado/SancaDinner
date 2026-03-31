package com.ifsp.edu.sanca_dinner.domain.model;

import com.ifsp.edu.sanca_dinner.domain.exception.DomainException;
import lombok.AccessLevel;
import lombok.Getter;

import java.util.UUID;

@Getter
public class User {
    private UUID id;
    private String name;
    private String email;
    private UserRoles role;

    @Getter(AccessLevel.NONE)
    private String password;

    public User(UUID id, String name, String email, String password, UserRoles role) {
        this.id = id;
        setName(name);
        setEmail(email);
        setPassword(password);
        setRole(role);
    }

    private void validateName(String name){
        if(name == null || name.isBlank()) throw new DomainException("O nome do usuário não pode ser vazio ou nulo.");
    }

    private void validateEmail(String email){
        if(email == null || email.isBlank()) throw new DomainException("O email do usuário não pode ser vazio ou nulo.");
        if(!email.contains("@")) throw new DomainException("O email informado é inválido.");
    }

    private void validatePassword(String password){
        if(password == null || password.isBlank()) throw new DomainException("A senha do usuário não pode ser vazio ou nulo.");
    }

    private void validateRole(UserRoles role){
        if(role == null) throw new DomainException("O cargo do usuário não pode ser nulo.");
    }

    public void setName(String name) {
        validateName(name);
        this.name = name;
    }

    public void setEmail(String email) {
        validateEmail(email);
        this.email = email;
    }

    public void setPassword(String password) {
        validatePassword(password);
        this.password = password;
    }

    public void setRole(UserRoles role) {
        validateRole(role);
        this.role = role;
    }
}