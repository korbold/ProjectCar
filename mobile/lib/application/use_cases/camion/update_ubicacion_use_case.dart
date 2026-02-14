import '../../../core/repositories/camion_repository.dart';

class UpdateUbicacionUseCase {
  UpdateUbicacionUseCase(this._repo);
  final CamionRepository _repo;

  Future<void> call(String camionId, double lat, double lng) =>
      _repo.updateUbicacion(camionId, lat, lng);
}
