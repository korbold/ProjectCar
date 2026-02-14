import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and reads user role and JWT. Used to decide initial screen and to authorize API calls.
class AuthService {
  static const String _keyRole = 'user_role';
  static const String _keyToken = 'auth_token';
  static const String _baseUrl = 'http://10.0.2.2:8080';

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

  /// Returns stored JWT for authenticated requests. Null if not logged in or mock login.
  Future<String?> getStoredToken() async {
    return _prefs.getString(_keyToken);
  }

  /// Saves role and optional token after login.
  Future<void> saveRole(String role, {String? token}) async {
    await _prefs.setString(_keyRole, role);
    if (token != null) {
      await _prefs.setString(_keyToken, token);
    } else {
      await _prefs.remove(_keyToken);
    }
  }

  /// Clears stored role and token (logout).
  Future<void> logout() async {
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyToken);
  }

  /// Tries POST /auth/login first. On success saves token and role (CONDUCTOR -> DRIVER). Falls back to mock login.
  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String?;
        final role = data['role'] as String?;
        if (token != null && role != null) {
          final appRole = role == 'CONDUCTOR' ? 'DRIVER' : 'USER';
          await saveRole(appRole, token: token);
          return appRole;
        }
      }
    } catch (_) {}
    // Fallback: mock login
    final role = email.toLowerCase().contains('conductor') || email.toLowerCase().contains('driver')
        ? 'DRIVER'
        : 'USER';
    await saveRole(role);
    return role;
  }
}
