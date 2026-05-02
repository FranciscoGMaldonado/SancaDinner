package com.ifsp.edu.sanca_dinner.infrastructure.security;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

@Component
public class SecurityExceptionHandler {

    public AuthenticationEntryPoint unauthorizedHandler() {
        return (request, response, ex) -> {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Email ou Senha Inválidos.\"}");
        };
    }

    public AccessDeniedHandler accessDeniedHandler() {
        return (request, response, ex) -> {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Acesso negado.\"}");
        };
    }
}