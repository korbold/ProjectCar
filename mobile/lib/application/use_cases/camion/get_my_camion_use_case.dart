import '../../../core/entities/camion.dart';
import '../../../core/repositories/camion_repository.dart';

class GetMyCamionUseCase {
  GetMyCamionUseCase(this._repo);
  final CamionRepository _repo;

  Future<Camion?> call() => _repo.getMyCamion();
}
