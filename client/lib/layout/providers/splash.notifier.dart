import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash.notifier.g.dart';

@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  Future<AuthStatus> build() async {
    await Future.delayed(Duration(seconds: 3));
    final authMode = ref.watch(authenticationProvider);
    return authMode.value!;
  }

  Future<void> onClick() async {
    await ref.read(authenticationProvider.notifier).splash();
  }
}
