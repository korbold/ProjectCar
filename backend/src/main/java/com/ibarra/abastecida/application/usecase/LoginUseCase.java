package com.ibarra.abastecida.application.usecase;

import com.ibarra.abastecida.domain.entity.LoginResult;
import com.ibarra.abastecida.domain.port.AuthPort;
import org.springframework.stereotype.Service;

/**
 * Use case: authenticate user and return token and role.
 */
@Service
public class LoginUseCase {

    private final AuthPort authPort;

    public LoginUseCase(AuthPort authPort) {
        this.authPort = authPort;
    }

    public LoginResult execute(String email, String password) {
        return authPort.login(email, password);
    }
}
