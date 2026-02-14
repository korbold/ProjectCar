package com.ibarra.abastecida.application.usecase;

import com.ibarra.abastecida.domain.entity.Camion;
import com.ibarra.abastecida.domain.port.CamionRepositoryPort;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Use case: list all trucks (e.g. for the map).
 */
@Service
public class ListCamionesUseCase {

    private final CamionRepositoryPort camionRepository;

    public ListCamionesUseCase(CamionRepositoryPort camionRepository) {
        this.camionRepository = camionRepository;
    }

    public List<Camion> execute() {
        return camionRepository.findAll();
    }
}
