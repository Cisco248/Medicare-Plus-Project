// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplashNotifier)
final splashProvider = SplashNotifierProvider._();

final class SplashNotifierProvider
    extends $AsyncNotifierProvider<SplashNotifier, AuthStates> {
  SplashNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashNotifierHash();

  @$internal
  @override
  SplashNotifier create() => SplashNotifier();
}

String _$splashNotifierHash() => r'473a92e95db91aaff72ea915ef55e00f88ab73d1';

abstract class _$SplashNotifier extends $AsyncNotifier<AuthStates> {
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
