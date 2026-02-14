import 'package:shared_preferences/shared_preferences.dart';

/// Persists and reads user role. Used to decide initial screen (Login, ClientMap, DriverControl).
class AuthService {
  static const String _keyRole = 'user_role';

  final SharedPreferences _prefs;

  AuthService(this._prefs);

  /// Creates AuthService after initializing SharedPreferences.
  static Future<AuthService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthService(prefs);
  }

  /// Returns stored role: 'USER' (citizen) or 'DRIVER' (conductor). Null if not logged in.
  Future<String?> getStoredRole() async {
    return _prefs.getString(_keyRole);
  }

  /// Saves role after login. [role] must be 'USER' or 'DRIVER'.
  Future<void> saveRole(String role) async {
    await _prefs.setString(_keyRole, role);
  }

  /// Clears stored role (logout).
  Future<void> logout() async {
    await _prefs.remove(_keyRole);
  }

  /// Mock login: accepts any email/password and assigns role by email suffix or fixed rule.
  /// Returns the role that was saved. For real auth, replace with POST /auth/login.
  Future<String> login(String email, String password) async {
    // Mock: driver@... or conductor@... -> DRIVER, else USER
    final role = email.toLowerCase().contains('conductor') || email.toLowerCase().contains('driver')
        ? 'DRIVER'
        : 'USER';
    await saveRole(role);
    return role;
  }
}
