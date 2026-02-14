import '../../../core/entities/camion.dart';
import '../../../core/repositories/camion_repository.dart';

class GetCamionesUseCase {
  GetCamionesUseCase(this._repo);
  final CamionRepository _repo;

  Future<List<Camion>> call() => _repo.getCamiones();
}
