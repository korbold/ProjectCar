package com.ibarra.abastecida.application.usecase;

import com.ibarra.abastecida.domain.port.CamionRepositoryPort;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * Use case: update a truck's location.
 */
@Service
public class UpdateUbicacionUseCase {

    private final CamionRepositoryPort camionRepository;

    public UpdateUbicacionUseCase(CamionRepositoryPort camionRepository) {
        this.camionRepository = camionRepository;
    }

    /**
     * @return true if the truck existed and was updated, false if not found
     */
    public boolean execute(UUID camionId, double lat, double lng) {
        if (camionRepository.findById(camionId).isEmpty()) {
            return false;
        }
        camionRepository.updateUbicacion(camionId, lat, lng);
        return true;
    }
}
