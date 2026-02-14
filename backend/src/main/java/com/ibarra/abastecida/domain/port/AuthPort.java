package com.ibarra.abastecida.domain.port;

import com.ibarra.abastecida.domain.entity.LoginResult;

/**
 * Port for authentication. Implemented by the auth adapter.
 */
public interface AuthPort {

    /**
     * Authenticates the user and returns token and role.
     *
     * @throws org.springframework.security.core.AuthenticationException if credentials are invalid
     */
    LoginResult login(String email, String password);
}
