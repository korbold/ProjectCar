package com.ibarra.abastecida.web;

import com.ibarra.abastecida.application.usecase.LoginUseCase;
import com.ibarra.abastecida.dto.LoginRequest;
import com.ibarra.abastecida.dto.LoginResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "Auth", description = "Authentication (no JWT required)")
public class AuthController {

    private final LoginUseCase loginUseCase;

    @Operation(summary = "Login", description = "Authenticate with email and password. Returns JWT and role (ADMIN, CONDUCTOR).")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Success", content = @Content(schema = @Schema(implementation = LoginResponse.class))),
            @ApiResponse(responseCode = "401", description = "Invalid credentials")
    })
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
