import '../entities/camion.dart';

/// Port for truck data. Implemented by infrastructure.
abstract class CamionRepository {
  Future<List<Camion>> getCamiones();
  Future<Camion?> getMyCamion();
  Future<void> updateUbicacion(String camionId, double lat, double lng);
}
