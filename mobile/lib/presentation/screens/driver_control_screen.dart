import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../application/use_cases/camion/get_my_camion_use_case.dart';
import '../../application/use_cases/camion/update_ubicacion_use_case.dart';
import '../../core/repositories/camion_repository.dart';
import '../providers/auth_provider.dart';
import '../providers/repository_providers.dart';

/// Driver screen: large button toggles EN SERVICIO (green) / FUERA DE SERVICIO (red).
/// When in service, sends position to backend every 10 seconds via Geolocator stream.
class DriverControlScreen extends ConsumerStatefulWidget {
  const DriverControlScreen({super.key});

  @override
  ConsumerState<DriverControlScreen> createState() => _DriverControlScreenState();
}

class _DriverControlScreenState extends ConsumerState<DriverControlScreen> {
  bool _inService = false;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _sendTimer;
  CamionRepository? _camionRepo;
  bool _camionIdLoaded = false;
  String? _camionId;
  String? _error;

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      if (mounted) setState(() => _error = 'Location permission denied');
      return;
    }
    await Permission.locationAlways.request();
    final geoStatus = await Geolocator.checkPermission();
    if (geoStatus == LocationPermission.denied || geoStatus == LocationPermission.deniedForever) {
      if (mounted) setState(() => _error = 'Location permission denied');
      return;
    }
  }

  void _toggleService() async {
    if (_inService) {
      _positionSubscription?.cancel();
      _positionSubscription = null;
      _sendTimer?.cancel();
      _sendTimer = null;
      setState(() {
        _inService = false;
        _error = null;
      });
      return;
    }

    await _requestLocationPermission();
    if (!mounted) return;

    final repo = _camionRepo;
    if (repo == null) return;

    _inService = true;
    _error = null;

    const interval = Duration(seconds: 10);
    Position? lastPosition;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationTitle: 'Ibarra Abastecida',
            notificationText: 'Compartiendo ubicación del camión en tiempo real',
            enableWifiLock: true,
          ),
        ),
      ).listen((Position position) {
        lastPosition = position;
      });
    } else {
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        lastPosition = position;
      });
    }

    _sendTimer = Timer.periodic(interval, (_) async {
      if (lastPosition == null || _camionId == null) return;
      try {
        await UpdateUbicacionUseCase(repo).call(
          _camionId!,
          lastPosition!.latitude,
          lastPosition!.longitude,
        );
        if (mounted) setState(() => _error = null);
      } catch (e) {
        if (mounted) setState(() => _error = e.toString());
      }
    });

    Future.delayed(const Duration(seconds: 2), () async {
      final pos = await Geolocator.getCurrentPosition();
      if (_camionId != null && mounted && _inService) {
        try {
          await UpdateUbicacionUseCase(repo).call(_camionId!, pos.latitude, pos.longitude);
        } catch (_) {}
      }
    });

    setState(() {});
  }

  Future<void> _loadDriverCamionId() async {
    try {
      final repo = await ref.read(camionRepositoryProvider.future);
      if (!mounted) return;
      setState(() => _camionRepo = repo);
      final camion = await GetMyCamionUseCase(repo).call();
      if (mounted) {
        setState(() => _camionId = camion?.id);
      }
    } catch (_) {
      if (mounted) setState(() => _camionId = null);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _sendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_camionIdLoaded) {
      _camionIdLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadDriverCamionId());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                height: 120,
                child: FilledButton(
                  onPressed: _toggleService,
                  style: FilledButton.styleFrom(
                    backgroundColor: _inService ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _inService ? 'EN SERVICIO' : 'FUERA DE SERVICIO',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (_camionId == null)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('No truck assigned; location will not be sent.', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
