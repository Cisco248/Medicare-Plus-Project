import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/models/user_model.dart';
import 'package:client/feature/auth/services/setup_key.service.dart';
import 'package:client/feature/auth/services/token.service.dart';
import 'package:client/feature/auth/services/user.service.dart';
import 'package:client/feature/auth/viewmodels/form_mode.notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication.notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthenticationNotifier extends _$AuthenticationNotifier {
  final _service = UserService();
  final _setupKey = SetupKeyService();
  final _tokenKey = UserTokenService();

  @override
  Future<AuthStatus> build() async {
    final isSetupOk = await _setupKey.getKey();
    if (!isSetupOk) {
      if (kDebugMode) {
        print(isSetupOk);
      }
      return const AuthStatus(state: AuthMode.setup);
    }
    final tokenKey = await _tokenKey.getTokenKey();
    if (kDebugMode) {
      print(tokenKey);
    }
    if (tokenKey == null || tokenKey.isEmpty) {
      return const AuthStatus(state: AuthMode.unauthenticated, token: null);
    }
    return AuthStatus(state: AuthMode.authenticated, token: tokenKey);
  }

  Future<AuthStatus> splash() async {
    state = AsyncValue.loading();
    try {
      await _setupKey.setKey();
      state = AsyncValue.data(AuthStatus(state: AuthMode.unauthenticated));
      return AuthStatus(state: AuthMode.unauthenticated);
    } catch (_) {
      return AuthStatus(state: AuthMode.setup);
    }
  }

  Future<void> login(String email, String password, bool isRemember) async {
    state = const AsyncValue.loading();
    try {
      final token = await _service.loginService(email, password);
      state = await AsyncValue.guard(() async {
        if (token.isEmpty || token == '') {
          return AuthStatus(state: AuthMode.unauthenticated, token: null);
        }
        if (isRemember == true) {
          return AuthStatus(state: AuthMode.authenticated, token: token);
        }
        await _tokenKey.setTokenKey(token);
        return AuthStatus(state: AuthMode.authenticated, token: null);
      });
    } catch (_) {
      state = AsyncValue.data(AuthStatus(state: AuthMode.unauthenticated));
    }
  }

  Future<void> register(UserModel data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _service.registerService(data);
      await _setupKey.setKey();
      ref.read(formStateProvider.notifier).toggle();
      return const AuthStatus(state: AuthMode.unauthenticated, token: null);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _tokenKey.removeToken();
      return const AuthStatus(state: AuthMode.unauthenticated);
    });
  }
}
