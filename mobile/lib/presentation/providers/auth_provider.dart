import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/use_cases/auth/get_auth_state_use_case.dart';
import '../../application/use_cases/auth/login_use_case.dart';
import '../../application/use_cases/auth/logout_use_case.dart';
import '../../core/entities/auth_state.dart';
import 'repository_providers.dart';

/// Exposes auth state and login/logout via use cases. State is null when not logged in.
class AuthNotifier extends AsyncNotifier<AuthState?> {
  @override
  Future<AuthState?> build() async {
    final repo = await ref.read(authRepositoryProvider.future);
    return GetAuthStateUseCase(repo).call();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final repo = await ref.read(authRepositoryProvider.future);
      final authState = await LoginUseCase(repo).call(email, password);
      state = AsyncData(authState);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    final repo = await ref.read(authRepositoryProvider.future);
    await LogoutUseCase(repo).call();
    state = const AsyncData(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState?>(AuthNotifier.new);
