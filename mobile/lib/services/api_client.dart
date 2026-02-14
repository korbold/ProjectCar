import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/camion.dart';

/// HTTP client for backend API. Base URL should point to host (e.g. 10.0.2.2:8080 on Android emulator).
class ApiClient {
  ApiClient({String baseUrl = 'http://10.0.2.2:8080/api'}) : _baseUrl = baseUrl;

  final String _baseUrl;

  /// GET /camiones - list trucks with location for map markers.
  Future<List<Camion>> getCamiones() async {
    final response = await http.get(Uri.parse('$_baseUrl/camiones'));
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }
    final list = jsonDecode(response.body) as List<dynamic>? ?? [];
    return list.map((e) => Camion.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// PATCH /camiones/:id/ubicacion - update truck location (driver in service).
  Future<void> updateCamionUbicacion(String camionId, double lat, double lng) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/camiones/$camionId/ubicacion'),
      headers: {'Content-Type': 'application/json'},
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
