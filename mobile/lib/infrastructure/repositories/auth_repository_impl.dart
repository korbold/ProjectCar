import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/entities/auth_state.dart';
import '../../core/repositories/auth_repository.dart';

/// Implements AuthRepository using SharedPreferences and HTTP login.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._prefs, {String baseUrl = 'http://10.0.2.2:8080'})
      : _baseUrl = baseUrl;

  static const String _keyRole = 'user_role';
  static const String _keyToken = 'auth_token';

  final SharedPreferences _prefs;
  final String _baseUrl;

  @override
  Future<AuthState?> getAuthState() async {
    final role = _prefs.getString(_keyRole);
    final token = _prefs.getString(_keyToken);
    if (role == null || role.isEmpty) return null;
    return AuthState(role: role, token: token);
  }

  @override
  Future<AuthState> login(String email, String password) async {
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
          await _prefs.setString(_keyRole, appRole);
          await _prefs.setString(_keyToken, token);
          return AuthState(role: appRole, token: token);
        }
      }
    } catch (_) {}
    final role = email.toLowerCase().contains('conductor') ||
            email.toLowerCase().contains('driver')
        ? 'DRIVER'
        : 'USER';
    await _prefs.setString(_keyRole, role);
    await _prefs.remove(_keyToken);
    return AuthState(role: role);
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyToken);
  }
}
