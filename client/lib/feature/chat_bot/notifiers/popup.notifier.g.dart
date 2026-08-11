// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popup.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PopUpNotifier)
final popUpProvider = PopUpNotifierProvider._();

final class PopUpNotifierProvider
    extends $NotifierProvider<PopUpNotifier, bool> {
  PopUpNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popUpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popUpNotifierHash();

  @$internal
  @override
  PopUpNotifier create() => PopUpNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$popUpNotifierHash() => r'9d8f1d5cda348a18a67733153a0705f509db57af';

abstract class _$PopUpNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
