import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/repositories/auth_repository.dart';
import '../../core/repositories/camion_repository.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';
import '../../infrastructure/repositories/camion_repository_impl.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AuthRepositoryImpl(prefs);
});

final camionRepositoryProvider = FutureProvider<CamionRepository>((ref) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  return CamionRepositoryImpl(authRepo);
});
