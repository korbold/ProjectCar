package com.ibarra.abastecida.application.usecase;

import com.ibarra.abastecida.domain.entity.Camion;
import com.ibarra.abastecida.domain.port.CamionRepositoryPort;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Use case: get the truck assigned to the given driver email.
 */
@Service
public class GetMyCamionUseCase {

    private final CamionRepositoryPort camionRepository;

    public GetMyCamionUseCase(CamionRepositoryPort camionRepository) {
        this.camionRepository = camionRepository;
    }

    public Optional<Camion> execute(String conductorEmail) {
        return camionRepository.findByConductorEmail(conductorEmail);
    }
}
