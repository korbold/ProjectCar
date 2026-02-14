import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../application/use_cases/camion/get_camiones_use_case.dart';
import '../../core/entities/camion.dart';
import '../../infrastructure/http/api_client.dart';
import '../providers/auth_provider.dart';
import '../providers/repository_providers.dart';

/// Full-screen map. Polls GET /camiones every 30 seconds and updates markers.
class ClientMapScreen extends ConsumerStatefulWidget {
  const ClientMapScreen({super.key});

  @override
  ConsumerState<ClientMapScreen> createState() => _ClientMapScreenState();
}

class _ClientMapScreenState extends ConsumerState<ClientMapScreen> {
  static const _ibarraCenter = LatLng(-0.3517, -78.1223);

  bool _timerStarted = false;
  List<Camion> _camiones = [];
  Timer? _timer;
  bool _loading = true;
  String? _error;

  Future<void> _fetchCamiones() async {
    try {
      final repo = await ref.read(camionRepositoryProvider.future);
      final list = await GetCamionesUseCase(repo).call();
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

  @override
  Widget build(BuildContext context) {
    if (!_timerStarted) {
      _timerStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchCamiones();
        _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchCamiones());
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
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
