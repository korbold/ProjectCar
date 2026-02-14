import '../../../core/entities/auth_state.dart';
import '../../../core/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repo);
  final AuthRepository _repo;

  Future<AuthState> call(String email, String password) =>
      _repo.login(email, password);
}
