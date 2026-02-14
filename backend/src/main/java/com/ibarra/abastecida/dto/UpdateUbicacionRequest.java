package com.ibarra.abastecida.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request body for PATCH /camiones/{id}/ubicacion.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUbicacionRequest {

    @NotNull
    private Double lat;

    @NotNull
    private Double lng;
}
