import '../../core/entities/camion.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/repositories/camion_repository.dart';
import '../http/api_client.dart';
import '../http/api_config.dart';

/// Implements CamionRepository using ApiClient. Token comes from AuthRepository.
class CamionRepositoryImpl implements CamionRepository {
  CamionRepositoryImpl(AuthRepository authRepo, {String? baseUrl})
      : _client = ApiClient(
          baseUrl: baseUrl ?? backendApiUrl,
          getToken: () async {
            final state = await authRepo.getAuthState();
            return state?.token;
          },
        );

  final ApiClient _client;

  @override
  Future<List<Camion>> getCamiones() => _client.getCamiones();

  @override
  Future<Camion?> getMyCamion() => _client.getMyCamion();

  @override
  Future<void> updateUbicacion(String camionId, double lat, double lng) =>
      _client.updateCamionUbicacion(camionId, lat, lng);
}
