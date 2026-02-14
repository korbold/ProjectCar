package com.ibarra.abastecida.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * API response for a truck (GET /camiones). Ubicacion as lat/lng for clients.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CamionResponse {

    private UUID id;
    private String placa;
    private UbicacionDto ubicacion;
    private ConductorRefDto conductor;
    private boolean activo;
    private LocalDateTime ultimoReporte;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UbicacionDto {
        private double lat;
        private double lng;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ConductorRefDto {
        private Long id;
        private String email;
    }
}
