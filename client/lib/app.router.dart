import 'package:client/core/components/loading.component.dart';
import 'package:client/core/components/splash.component.dart';
import 'package:client/layout/page/layout.page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'feature/auth/models/auth.model.dart';
import 'feature/auth/pages/auth.page.dart';
import 'feature/auth/viewmodels/authentication.notifier.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authChangeNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const GetStartedPage(),
      ),
      GoRoute(path: '/auth', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const AppLoadingPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const AppLayout()),
    ],
    redirect: (context, state) {
      final authState = ref.read(authenticationProvider);
      final authStatus = authState.value?.state;
      if (kDebugMode) {
        print(authStatus);
      }

      if (authState.isLoading) return '/loading';
      if (authState.hasError) return null;

      switch (authStatus) {
        case AuthMode.setup:
          return '/splash';

        case AuthMode.unauthenticated:
          return '/auth';

        case AuthMode.authenticated:
          return '/home';

        case AuthMode.initial:
        case null:
          return '/splash';
      }
    },
  );
});

class AuthChangeNotifier extends ChangeNotifier {
  final Ref ref;

  AuthChangeNotifier(this.ref) {
    ref.listen(authenticationProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final authChangeNotifierProvider = Provider<AuthChangeNotifier>((ref) {
  return AuthChangeNotifier(ref);
});
