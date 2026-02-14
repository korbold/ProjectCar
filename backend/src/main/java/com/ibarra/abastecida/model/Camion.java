package com.ibarra.abastecida.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Truck entity with driver reference and WGS84 (SRID 4326) location.
 */
@Entity
@Table(name = "camion")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Camion {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private String placa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conductor_id", referencedColumnName = "id")
    private Usuario conductor;

    @Column(columnDefinition = "geometry(Point,4326)")
    private Point ubicacion;

    @Column(nullable = false)
    @Builder.Default
    private boolean activo = true;

    private LocalDateTime ultimoReporte;
}
