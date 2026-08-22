// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PermissionsNotifier)
final permissionsProvider = PermissionsNotifierProvider._();

final class PermissionsNotifierProvider
    extends
        $AsyncNotifierProvider<PermissionsNotifier, List<AppPermissionItem>> {
  PermissionsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionsNotifierHash();

  @$internal
  @override
  PermissionsNotifier create() => PermissionsNotifier();
}

String _$permissionsNotifierHash() =>
    r'615c7c11c5463f63205638ac5b6fe1a7c0b42745';

abstract class _$PermissionsNotifier
    extends $AsyncNotifier<List<AppPermissionItem>> {
  FutureOr<List<AppPermissionItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AppPermissionItem>>,
              List<AppPermissionItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AppPermissionItem>>,
                List<AppPermissionItem>
              >,
              AsyncValue<List<AppPermissionItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
