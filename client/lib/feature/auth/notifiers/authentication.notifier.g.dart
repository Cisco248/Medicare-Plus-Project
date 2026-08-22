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
    r'90f6211a31977e2e03f19ea02ac68437c5d21c2b';

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
