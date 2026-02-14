/// Shared backend URL configuration. Used by ApiClient and WebSocket (STOMP) client.
const String backendBaseUrl = 'http://10.0.2.2:8080';

/// API base URL for REST calls (e.g. GET /camiones).
String get backendApiUrl => '$backendBaseUrl/api';

/// WebSocket URL for STOMP (e.g. ws://10.0.2.2:8080/ws).
String get backendWsUrl {
  final uri = Uri.parse(backendBaseUrl);
  final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
  return '$scheme://${uri.host}:${uri.port}/ws';
}
