package com.ibarra.abastecida.web;

import com.ibarra.abastecida.dto.CamionResponse;
import com.ibarra.abastecida.dto.UpdateUbicacionRequest;
import com.ibarra.abastecida.model.Camion;
import com.ibarra.abastecida.model.Usuario;
import com.ibarra.abastecida.repository.CamionRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * REST controller for trucks: list (for map) and update location (driver).
 */
@RestController
@RequestMapping("/api/camiones")
@RequiredArgsConstructor
public class CamionController {

    private static final GeometryFactory GEOMETRY_FACTORY =
            new GeometryFactory(new PrecisionModel(), 4326);

    private final CamionRepository camionRepository;

    @GetMapping
    public List<CamionResponse> list() {
        return camionRepository.findAll().stream()
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
        String emailConductor = auth.getName();
        return camionRepository.findByConductor_Email(emailConductor)
                .map(this::toResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}/ubicacion")
    public ResponseEntity<Void> updateUbicacion(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateUbicacionRequest body) {
        Camion camion = camionRepository.findById(id).orElse(null);
        if (camion == null) {
            return ResponseEntity.notFound().build();
        }
        camion.setUbicacion(
                GEOMETRY_FACTORY.createPoint(new Coordinate(body.getLng(), body.getLat())));
        camion.setUltimoReporte(java.time.LocalDateTime.now());
        camionRepository.save(camion);
        return ResponseEntity.noContent().build();
    }

    private CamionResponse toResponse(Camion c) {
        CamionResponse.UbicacionDto ub = null;
        if (c.getUbicacion() != null) {
            ub = new CamionResponse.UbicacionDto(
                    c.getUbicacion().getY(),
                    c.getUbicacion().getX());
        }
        CamionResponse.ConductorRefDto cond = null;
        Usuario conductor = c.getConductor();
        if (conductor != null) {
            cond = new CamionResponse.ConductorRefDto(conductor.getId(), conductor.getEmail());
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
