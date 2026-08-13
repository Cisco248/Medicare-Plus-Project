// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthenticationNotifier)
final authenticationProvider = AuthenticationNotifierProvider._();

final class AuthenticationNotifierProvider
    extends $AsyncNotifierProvider<AuthenticationNotifier, AuthStatus> {
  AuthenticationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationNotifierHash();

  @$internal
  @override
  AuthenticationNotifier create() => AuthenticationNotifier();
}

String _$authenticationNotifierHash() =>
    r'0856297815fe7581dfdaac2f3553f78b8a44fccb';

abstract class _$AuthenticationNotifier extends $AsyncNotifier<AuthStatus> {
  FutureOr<AuthStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthStatus>, AuthStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthStatus>, AuthStatus>,
              AsyncValue<AuthStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
