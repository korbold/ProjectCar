package com.ibarra.abastecida.adapter.auth;

import com.ibarra.abastecida.config.JwtService;
import com.ibarra.abastecida.domain.entity.LoginResult;
import com.ibarra.abastecida.domain.port.AuthPort;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.Collection;

/**
 * Auth adapter: implements AuthPort using Spring Security and JWT.
 */
@Component
public class AuthAdapter implements AuthPort {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    public AuthAdapter(AuthenticationManager authenticationManager, JwtService jwtService) {
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }

    @Override
    public LoginResult login(String email, String password) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(email, password));
        String role = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .filter(a -> a.startsWith("ROLE_"))
                .map(a -> a.substring(5))
                .findFirst()
                .orElse("USER");
        String token = jwtService.generateToken(authentication.getName(), role);
        return LoginResult.builder()
                .token(token)
                .role(role)
                .build();
    }
}
