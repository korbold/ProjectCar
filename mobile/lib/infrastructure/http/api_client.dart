import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/entities/camion.dart';

/// HTTP client for backend API. Infrastructure detail used by CamionRepositoryImpl.
class ApiClient {
  ApiClient({
    String baseUrl = 'http://10.0.2.2:8080/api',
    Future<String?> Function()? getToken,
  })  : _baseUrl = baseUrl,
        _getToken = getToken ?? (() async => null);

  final String _baseUrl;
  final Future<String?> Function() _getToken;

  Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<Camion>> getCamiones() async {
    final response = await http.get(Uri.parse('$_baseUrl/camiones'));
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }
    final list = jsonDecode(response.body) as List<dynamic>? ?? [];
    return list.map((e) => Camion.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Camion?> getMyCamion() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/camiones/mi-camion'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }
    return Camion.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> updateCamionUbicacion(String camionId, double lat, double lng) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/camiones/$camionId/ubicacion'),
      headers: await _authHeaders(),
      body: jsonEncode({'lat': lat, 'lng': lng}),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}

class ApiException implements Exception {
  ApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'ApiException($statusCode): $body';
}
