import 'package:client/core/configs/config.dart';
import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:client/feature/auth/notifiers/form_mode.notifier.dart';
import 'package:client/feature/auth/services/setup_key.service.dart';
import 'package:client/feature/auth/services/token.service.dart';
import 'package:client/feature/auth/services/user.service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication.notifier.g.dart';

final _service = UserService();
final _setupKey = SetupKeyService();
final _tokenKey = UserTokenService();

@Riverpod(keepAlive: true)
class AuthenticationNotifier extends _$AuthenticationNotifier {
  @override
  Future<AuthStates> build() async {
    final isSetupOk = await _setupKey.getupKey();
    if (!isSetupOk) {
      return const AuthStates(state: AuthMode.setup, data: null);
    }
    final tokenKey = await _tokenKey.getTokenKey(userTokenKey);
    if (tokenKey == null || tokenKey.isEmpty) {
      return const AuthStates(state: AuthMode.unauthenticated, data: null);
    }

    final id = await _setupKey.getKey(userIDKey);

    try {
      final res = await _service.profileService(id, tokenKey);
      return AuthStates(state: AuthMode.authenticated, data: res);
    } catch (e) {
      return const AuthStates(state: AuthMode.unauthenticated);
    }
  }

  Future<AuthStates> splash() async {
    state = AsyncValue.loading();
    try {
      await _setupKey.setupKey();
      state = AsyncValue.data(AuthStates(state: AuthMode.unauthenticated));
      return AuthStates(state: AuthMode.unauthenticated);
    } catch (_) {
      return AuthStates(state: AuthMode.setup);
    }
  }

  Future<void> login(String email, String password, bool isRemember) async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.loginService(email, password);
      if (isRemember) {
        await _tokenKey.setTokenKey(userTokenKey, result.token);
        await _setupKey.setKey(userIDKey, result.id);
      }
      state = AsyncValue.data(
        AuthStates(
          state: AuthMode.authenticated,
          data: AuthResponseModel(
            token: result.token,
            id: result.id,
            name: result.name,
            email: result.email,
            mobnum: result.mobnum,
            password: '',
          ),
        ),
      );
    } catch (error) {
      state = const AsyncValue.data(
        AuthStates(state: AuthMode.unauthenticated),
      );
      rethrow;
    }
  }

  Future<void> register(AuthRequestModel data) async {
    state = const AsyncValue.loading();
    try {
      final created = await _service.registerService(data);
      if (!created) {
        throw const UnknownException(message: 'Unable to create your account.');
      }
      await _setupKey.setupKey();
      ref.read(formStateProvider.notifier).toggle();
      state = const AsyncValue.data(
        AuthStates(state: AuthMode.unauthenticated),
      );
    } catch (error) {
      state = const AsyncValue.data(
        AuthStates(state: AuthMode.unauthenticated),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _tokenKey.removeToken();
      return const AuthStates(
        state: AuthMode.unauthenticated,
        data: AuthResponseModel(token: ''),
      );
    });
  }
}
