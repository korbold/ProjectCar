package com.ibarra.abastecida.domain.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain entity for a truck. No JPA or infrastructure dependencies.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Camion {

    private UUID id;
    private String placa;
    private Double lat;
    private Double lng;
    private Long conductorId;
    private String conductorEmail;
    private boolean activo;
    private LocalDateTime ultimoReporte;
}
