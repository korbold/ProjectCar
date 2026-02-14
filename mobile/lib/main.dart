import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/client_map_screen.dart';
import 'presentation/screens/driver_control_screen.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Root app: watches auth state and shows Login, ClientMap, or DriverControl.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authNotifierProvider);

    return MaterialApp(
      title: 'Ibarra Abastecida',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: authAsync.when(
        data: (auth) {
          if (auth == null || auth.role.isEmpty) {
            return const LoginScreen();
          }
          if (auth.role == 'DRIVER') {
            return const DriverControlScreen();
          }
          return const ClientMapScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $err', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(authNotifierProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
