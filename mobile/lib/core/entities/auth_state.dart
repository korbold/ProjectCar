/// Logged-in user: role (USER/DRIVER) and optional JWT token. Domain entity.
class AuthState {
  const AuthState({required this.role, this.token});
  final String role;
  final String? token;
}
