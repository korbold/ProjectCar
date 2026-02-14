import '../../../core/repositories/auth_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this._repo);
  final AuthRepository _repo;

  Future<void> call() => _repo.logout();
}
