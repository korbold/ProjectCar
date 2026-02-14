package com.ibarra.abastecida.web;

import com.ibarra.abastecida.application.usecase.LoginUseCase;
import com.ibarra.abastecida.dto.LoginRequest;
import com.ibarra.abastecida.dto.LoginResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final LoginUseCase loginUseCase;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        var result = loginUseCase.execute(request.getEmail(), request.getPassword());
        return ResponseEntity.ok(
                LoginResponse.builder()
                        .token(result.getToken())
                        .role(result.getRole())
                        .build());
    }
}
