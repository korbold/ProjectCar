import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../services/auth_service.dart';
import 'package:latlong2/latlong.dart';

import '../models/camion.dart';
import '../services/api_client.dart';

/// Full-screen map. Polls GET /camiones every 30 seconds and updates markers.
class ClientMapScreen extends StatefulWidget {
  const ClientMapScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  State<ClientMapScreen> createState() => _ClientMapScreenState();
}

class _ClientMapScreenState extends State<ClientMapScreen> {
  static const _ibarraCenter = LatLng(-0.3517, -78.1223);

  final ApiClient _api = ApiClient();
  List<Camion> _camiones = [];
  Timer? _timer;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCamiones();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchCamiones());
  }

  Future<void> _fetchCamiones() async {
    try {
      final list = await _api.getCamiones();
      if (mounted) {
        setState(() {
          _camiones = list;
          _loading = false;
          _error = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '${e.statusCode}: ${e.body}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _logout() async {
    final auth = await AuthService.create();
    await auth.logout();
    widget.onLogout?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _ibarraCenter,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ibarra.abastecida.mobile',
              ),
              MarkerLayer(
                markers: _camiones
                    .where((c) => c.ubicacion != null)
                    .map((c) => Marker(
                          point: LatLng(c.ubicacion!.lat, c.ubicacion!.lng),
                          width: 32,
                          height: 32,
                          child: const Icon(Icons.local_shipping, color: Colors.blue, size: 32),
                        ))
                    .toList(),
              ),
            ],
          ),
          if (_loading && _camiones.isEmpty)
            const Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_error != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_error!, style: const TextStyle(color: Colors.black87)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
