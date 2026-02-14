import '../entities/auth_state.dart';

/// Port for auth persistence and login. Implemented by infrastructure.
abstract class AuthRepository {
  Future<AuthState?> getAuthState();
  Future<AuthState> login(String email, String password);
  Future<void> logout();
}
