/// Truck model for API responses (GET /camiones). Ubicacion may be lat/lng or backend-specific.
class Camion {
  Camion({
    required this.id,
    required this.placa,
    this.ubicacion,
    this.conductor,
    this.activo = true,
    this.ultimoReporte,
  });

  factory Camion.fromJson(Map<String, dynamic> json) {
    Object? lat;
    Object? lng;
    final ub = json['ubicacion'];
    if (ub is Map<String, dynamic>) {
      lat = ub['lat'] ?? ub['y'];
      lng = ub['lng'] ?? ub['x'];
    } else if (ub is List && ub.length >= 2) {
      lng = ub[0];
      lat = ub[1];
    }
    double? latDouble;
    double? lngDouble;
    if (lat != null && lng != null) {
      latDouble = (lat is num) ? lat.toDouble() : double.tryParse(lat.toString());
      lngDouble = (lng is num) ? lng.toDouble() : double.tryParse(lng.toString());
    }
    return Camion(
      id: json['id']?.toString() ?? '',
      placa: json['placa'] as String? ?? '',
      ubicacion: (latDouble != null && lngDouble != null)
          ? Ubicacion(lat: latDouble, lng: lngDouble)
          : null,
      conductor: json['conductor'] != null
          ? ConductorRef.fromJson(json['conductor'] as Map<String, dynamic>)
          : null,
      activo: json['activo'] as bool? ?? true,
      ultimoReporte: json['ultimoReporte'] as String?,
    );
  }

  final String id;
  final String placa;
  final Ubicacion? ubicacion;
  final ConductorRef? conductor;
  final bool activo;
  final String? ultimoReporte;
}

class Ubicacion {
  Ubicacion({required this.lat, required this.lng});
  final double lat;
  final double lng;
}

class ConductorRef {
  ConductorRef({required this.id, this.email});
  factory ConductorRef.fromJson(Map<String, dynamic> json) {
    return ConductorRef(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      email: json['email'] as String?,
    );
  }
  final int id;
  final String? email;
}
