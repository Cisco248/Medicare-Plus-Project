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
    extends $AsyncNotifierProvider<AuthenticationNotifier, AuthStates> {
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
    r'67ffd30d52f72ba1687df69dd3e3d9867f90ad64';

abstract class _$AuthenticationNotifier extends $AsyncNotifier<AuthStates> {
  FutureOr<AuthStates> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthStates>, AuthStates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthStates>, AuthStates>,
              AsyncValue<AuthStates>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
