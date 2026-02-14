import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';

/// Driver screen: large button toggles EN SERVICIO (green) / FUERA DE SERVICIO (red).
/// When in service, sends position to backend every 10 seconds via Geolocator stream.
class DriverControlScreen extends StatefulWidget {
  const DriverControlScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  State<DriverControlScreen> createState() => _DriverControlScreenState();
}

class _DriverControlScreenState extends State<DriverControlScreen> {
  bool _inService = false;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _sendTimer;
  late final ApiClient _api = ApiClient(
    getToken: () async {
      final auth = await AuthService.create();
      return auth.getStoredToken();
    },
  );
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
        await _api.updateCamionUbicacion(
          _camionId!,
          lastPosition!.latitude,
          lastPosition!.longitude,
        );
        if (mounted) setState(() => _error = null);
      } catch (e) {
        if (mounted) setState(() => _error = e.toString());
      }
    });

    // Send once immediately if we have a position (after a short delay for first fix)
    Future.delayed(const Duration(seconds: 2), () async {
      final pos = await Geolocator.getCurrentPosition();
      if (_camionId != null && mounted && _inService) {
        try {
          await _api.updateCamionUbicacion(_camionId!, pos.latitude, pos.longitude);
        } catch (_) {}
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadDriverCamionId();
  }

  Future<void> _loadDriverCamionId() async {
    try {
      final camion = await _api.getMyCamion();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final auth = await AuthService.create();
              await auth.logout();
              widget.onLogout?.call();
            },
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
