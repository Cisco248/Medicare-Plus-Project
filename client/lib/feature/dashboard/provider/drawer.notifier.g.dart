// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DrawerNotifier)
final drawerProvider = DrawerNotifierProvider._();

final class DrawerNotifierProvider
    extends $NotifierProvider<DrawerNotifier, bool> {
  DrawerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drawerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drawerNotifierHash();

  @$internal
  @override
  DrawerNotifier create() => DrawerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$drawerNotifierHash() => r'cd15bc073efc2327fc78e23d6eac171c31ae33c4';

abstract class _$DrawerNotifier extends $Notifier<bool> {
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
