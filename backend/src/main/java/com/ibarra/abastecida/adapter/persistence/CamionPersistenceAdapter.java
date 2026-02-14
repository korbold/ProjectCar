package com.ibarra.abastecida.adapter.persistence;

import com.ibarra.abastecida.domain.entity.Camion;
import com.ibarra.abastecida.domain.port.CamionRepositoryPort;
import com.ibarra.abastecida.repository.CamionRepository;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Persistence adapter: implements CamionRepositoryPort using JPA.
 */
@Component
public class CamionPersistenceAdapter implements CamionRepositoryPort {

    private static final GeometryFactory GEOMETRY_FACTORY =
            new GeometryFactory(new PrecisionModel(), 4326);

    private final CamionRepository jpaRepository;

    public CamionPersistenceAdapter(CamionRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public List<Camion> findAll() {
        return jpaRepository.findAll().stream()
                .map(this::toDomain)
                .toList();
    }

    @Override
    public Optional<Camion> findByConductorEmail(String email) {
        return jpaRepository.findByConductor_Email(email)
                .map(this::toDomain);
    }

    @Override
    public Optional<Camion> findById(UUID id) {
        return jpaRepository.findById(id)
                .map(this::toDomain);
    }

    @Override
    public void updateUbicacion(UUID id, double lat, double lng) {
        com.ibarra.abastecida.model.Camion jpa = jpaRepository.findById(id).orElseThrow();
        jpa.setUbicacion(GEOMETRY_FACTORY.createPoint(new Coordinate(lng, lat)));
        jpa.setUltimoReporte(java.time.LocalDateTime.now());
        jpaRepository.save(jpa);
    }

    private Camion toDomain(com.ibarra.abastecida.model.Camion jpa) {
        Double lat = null;
        Double lng = null;
        if (jpa.getUbicacion() != null) {
            lat = jpa.getUbicacion().getY();
            lng = jpa.getUbicacion().getX();
        }
        Long conductorId = null;
        String conductorEmail = null;
        if (jpa.getConductor() != null) {
            conductorId = jpa.getConductor().getId();
            conductorEmail = jpa.getConductor().getEmail();
        }
        return Camion.builder()
                .id(jpa.getId())
                .placa(jpa.getPlaca())
                .lat(lat)
                .lng(lng)
                .conductorId(conductorId)
                .conductorEmail(conductorEmail)
                .activo(jpa.isActivo())
                .ultimoReporte(jpa.getUltimoReporte())
                .build();
    }
}
