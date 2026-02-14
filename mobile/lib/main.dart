import 'package:flutter/material.dart';

import 'screens/client_map_screen.dart';
import 'screens/driver_control_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

/// Root app: resolves initial role via FutureBuilder and shows Login, ClientMap, or DriverControl.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String?> _roleFuture = AuthService.create().then((a) => a.getStoredRole());

  void _refreshRole() {
    setState(() {
      _roleFuture = AuthService.create().then((a) => a.getStoredRole());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ibarra Abastecida',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: _roleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final role = snapshot.data;
          if (role == null || role.isEmpty) {
            return LoginScreen(onLoggedIn: _refreshRole);
          }
          if (role == 'DRIVER') {
            return DriverControlScreen(onLogout: _refreshRole);
          }
          return ClientMapScreen(onLogout: _refreshRole);
        },
      ),
    );
  }
}
