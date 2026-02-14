package com.ibarra.abastecida.web;

import com.ibarra.abastecida.application.usecase.GetMyCamionUseCase;
import com.ibarra.abastecida.application.usecase.ListCamionesUseCase;
import com.ibarra.abastecida.application.usecase.UpdateUbicacionUseCase;
import com.ibarra.abastecida.domain.entity.Camion;
import com.ibarra.abastecida.dto.CamionResponse;
import com.ibarra.abastecida.dto.UpdateUbicacionRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * REST controller for trucks: list (for map) and update location (driver).
 * Delegates to use cases and maps domain to DTOs.
 */
@RestController
@RequestMapping("/api/camiones")
@RequiredArgsConstructor
public class CamionController {

    private final ListCamionesUseCase listCamionesUseCase;
    private final GetMyCamionUseCase getMyCamionUseCase;
    private final UpdateUbicacionUseCase updateUbicacionUseCase;

    @GetMapping
    public List<CamionResponse> list() {
        return listCamionesUseCase.execute().stream()
                .map(this::toResponse)
                .toList();
    }

    /**
     * Returns the truck assigned to the currently authenticated driver (JWT).
     */
    @GetMapping("/mi-camion")
    public ResponseEntity<CamionResponse> getMiCamion(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) {
            return ResponseEntity.status(401).build();
        }
        return getMyCamionUseCase.execute(auth.getName())
                .map(this::toResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}/ubicacion")
    public ResponseEntity<Void> updateUbicacion(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateUbicacionRequest body) {
        boolean updated = updateUbicacionUseCase.execute(id, body.getLat(), body.getLng());
        return updated ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    private CamionResponse toResponse(Camion c) {
        CamionResponse.UbicacionDto ub = null;
        if (c.getLat() != null && c.getLng() != null) {
            ub = new CamionResponse.UbicacionDto(c.getLat(), c.getLng());
        }
        CamionResponse.ConductorRefDto cond = null;
        if (c.getConductorId() != null && c.getConductorEmail() != null) {
            cond = new CamionResponse.ConductorRefDto(c.getConductorId(), c.getConductorEmail());
        }
        return CamionResponse.builder()
                .id(c.getId())
                .placa(c.getPlaca())
                .ubicacion(ub)
                .conductor(cond)
                .activo(c.isActivo())
                .ultimoReporte(c.getUltimoReporte())
                .build();
    }
}
