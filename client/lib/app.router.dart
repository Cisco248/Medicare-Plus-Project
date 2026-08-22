import 'package:client/core/components/loading.component.dart';
import 'package:client/core/components/splash.component.dart';
import 'package:client/feature/auth/models/auth.state.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/auth/pages/auth.page.dart';
import 'package:client/layout/page/layout.page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authChangeNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',

    refreshListenable: authNotifier,

    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) {
          return const GetStartedPage();
        },
      ),

      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) {
          return const AppLoadingPage();
        },
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          return const AppLayout();
        },
      ),
    ],

    redirect: (context, state) {
      final authState = ref.read(authenticationProvider);
      if (kDebugMode) {
        debugPrint('AUTH STATE: $authState');
      }
      if (authState.isLoading) {
        return state.matchedLocation == '/loading' ? null : '/loading';
      }

      if (authState.hasError) {
        if (kDebugMode) {
          debugPrint('Authentication error: ${authState.error}');
        }

        return null;
      }

      final AuthMode authMode = authState.when(
        data: (auth) => auth.state,
        loading: () => AuthMode.initial,
        error: (_, _) => AuthMode.initial,
      );

      if (kDebugMode) {
        debugPrint('Auth Mode: $authMode');
        debugPrint('Current Route: ${state.matchedLocation}');
      }

      switch (authMode) {
        case AuthMode.initial:
          return state.matchedLocation == '/splash' ? null : '/splash';

        case AuthMode.setup:
          return state.matchedLocation == '/splash' ? null : '/splash';

        case AuthMode.unauthenticated:
          return state.matchedLocation == '/auth' ? null : '/auth';

        case AuthMode.authenticated:
          return state.matchedLocation == '/home' ? null : '/home';
      }
    },
  );
});

class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(this.ref) {
    ref.listen<AsyncValue<AuthStates>>(authenticationProvider, (
      previous,
      next,
    ) {
      notifyListeners();
    });
  }

  final Ref ref;
}

final authChangeNotifierProvider = Provider<AuthChangeNotifier>((ref) {
  return AuthChangeNotifier(ref);
});
