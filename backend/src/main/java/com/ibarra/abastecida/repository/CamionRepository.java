package com.ibarra.abastecida.repository;

import com.ibarra.abastecida.model.Camion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * JPA repository for Camion entity. Includes spatial query for trucks within a radius.
 */
public interface CamionRepository extends JpaRepository<Camion, UUID> {

    /**
     * Finds trucks whose location is within the given radius (in meters) of the given point.
     * Uses PostGIS ST_DWithin on geography for accurate distance in meters (SRID 4326).
     *
     * @param latitude  WGS84 latitude
     * @param longitude WGS84 longitude
     * @param radiusMeters radius in meters
     * @return list of trucks within the radius
     */
    @Query(value = """
        SELECT * FROM camion c
        WHERE c.ubicacion IS NOT NULL
        AND ST_DWithin(
            c.ubicacion::geography,
            ST_SetSRID(ST_MakePoint(:longitude, :latitude), 4326)::geography,
            :radiusMeters
        )
        """, nativeQuery = true)
    List<Camion> findWithinRadius(
            @Param("latitude") double latitude,
            @Param("longitude") double longitude,
            @Param("radiusMeters") double radiusMeters
    );

    /**
     * Returns the truck assigned to the driver with the given email.
     */
    Optional<Camion> findByConductor_Email(String email);
}
