package com.ibarra.abastecida.web;

import com.ibarra.abastecida.application.usecase.GetMyCamionUseCase;
import com.ibarra.abastecida.application.usecase.ListCamionesUseCase;
import com.ibarra.abastecida.application.usecase.UpdateUbicacionUseCase;
import com.ibarra.abastecida.domain.entity.Camion;
import com.ibarra.abastecida.dto.CamionResponse;
import com.ibarra.abastecida.dto.UpdateUbicacionRequest;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
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
@Tag(name = "Camiones", description = "Truck listing and location updates")
public class CamionController {

    private final ListCamionesUseCase listCamionesUseCase;
    private final GetMyCamionUseCase getMyCamionUseCase;
    private final UpdateUbicacionUseCase updateUbicacionUseCase;
    private final SimpMessagingTemplate messagingTemplate;

    @Operation(summary = "List all trucks", description = "Returns all trucks with location (for map). Public, no auth.")
    @ApiResponse(responseCode = "200", description = "List of trucks", content = @Content(schema = @Schema(implementation = CamionResponse.class)))
    @GetMapping
    public List<CamionResponse> list() {
        return listCamionesUseCase.execute().stream()
                .map(this::toResponse)
                .toList();
    }

    @Operation(summary = "My truck", description = "Returns the truck assigned to the authenticated driver (JWT required).", security = @SecurityRequirement(name = "bearerAuth"))
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Driver's truck", content = @Content(schema = @Schema(implementation = CamionResponse.class))),
            @ApiResponse(responseCode = "401", description = "Not authenticated"),
            @ApiResponse(responseCode = "404", description = "No truck assigned")
    })
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

    @Operation(summary = "Update truck location", description = "Updates the truck's GPS location (driver only).", security = @SecurityRequirement(name = "bearerAuth"))
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Updated"),
            @ApiResponse(responseCode = "401", description = "Not authenticated"),
            @ApiResponse(responseCode = "404", description = "Truck not found")
    })
    @PatchMapping("/{id}/ubicacion")
    public ResponseEntity<Void> updateUbicacion(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateUbicacionRequest body) {
        boolean updated = updateUbicacionUseCase.execute(id, body.getLat(), body.getLng());
        if (!updated) {
            return ResponseEntity.notFound().build();
        }
        listCamionesUseCase.execute().stream()
                .filter(c -> c.getId().equals(id))
                .findFirst()
                .map(this::toResponse)
                .ifPresent(response -> messagingTemplate.convertAndSend("/topic/camiones.ubicacion", response));
        return ResponseEntity.noContent().build();
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
