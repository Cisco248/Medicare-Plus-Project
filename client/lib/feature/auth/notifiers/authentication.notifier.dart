import 'package:client/core/configs/config.dart';
import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/models/auth.scheme.model.dart';
import 'package:client/feature/auth/notifiers/form_mode.notifier.dart';
import 'package:client/feature/auth/services/setup_key.service.dart';
import 'package:client/feature/auth/services/token.service.dart';
import 'package:client/feature/auth/services/user.service.dart';
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
      return const AuthStatus(state: AuthMode.setup);
    }
    final tokenKey = await _tokenKey.getTokenKey(userTokenKey);
    if (tokenKey == null || tokenKey.isEmpty) {
      return const AuthStatus(state: AuthMode.unauthenticated, token: null);
    }

    final email = await _tokenKey.getTokenKey(userEmailKey);
    final password = await _tokenKey.getTokenKey(userPasswordKey);
    if (email == null || password == null) {
      return AuthStatus(state: AuthMode.unauthenticated);
    }
    final data = await _service.loginService(email, password);
    return AuthStatus(
      state: AuthMode.authenticated,
      token: tokenKey,
      data: data.data,
    );
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
      final result = await _service.loginService(email, password);
      state = await AsyncValue.guard(() async {
        if (isRemember == true) {
          await _tokenKey.setTokenKey(userTokenKey, result.token);
          await _tokenKey.setTokenKey(userEmailKey, email);
          await _tokenKey.setTokenKey(userPasswordKey, password);
          return AuthStatus(
            state: AuthMode.authenticated,
            token: result.token,
            data: result.data,
          );
        }
        // Keep the session token in memory (not persisted) so authenticated
        // API calls work even when "remember me" is off.
        return AuthStatus(
          state: AuthMode.authenticated,
          token: result.token,
          data: result.data,
        );
      });
    } catch (_) {
      state = AsyncValue.data(AuthStatus(state: AuthMode.unauthenticated));
    }
  }

  Future<void> register(UserModel data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final result = await _service.registerService(data);
        if (result) {
          await _setupKey.setKey();
          ref.read(formStateProvider.notifier).toggle();
          return const AuthStatus(state: AuthMode.unauthenticated);
        }
        return const AuthStatus(state: AuthMode.setup);
      } catch (_) {
        return const AuthStatus(state: AuthMode.unauthenticated);
      }
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _tokenKey.removeToken();
      return const AuthStatus(state: AuthMode.unauthenticated, token: '');
    });
  }
}
