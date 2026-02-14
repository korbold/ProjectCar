import '../../../core/entities/auth_state.dart';
import '../../../core/repositories/auth_repository.dart';

class GetAuthStateUseCase {
  GetAuthStateUseCase(this._repo);
  final AuthRepository _repo;

  Future<AuthState?> call() => _repo.getAuthState();
}
