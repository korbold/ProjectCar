package com.ibarra.abastecida.domain.port;

import com.ibarra.abastecida.domain.entity.Camion;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port for truck persistence. Implemented by the persistence adapter.
 */
public interface CamionRepositoryPort {

    List<Camion> findAll();

    Optional<Camion> findByConductorEmail(String email);

    Optional<Camion> findById(UUID id);

    void updateUbicacion(UUID id, double lat, double lng);
}
