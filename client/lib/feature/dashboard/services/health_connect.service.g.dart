// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_connect.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(healthConnectService)
final healthConnectServiceProvider = HealthConnectServiceProvider._();

final class HealthConnectServiceProvider
    extends
        $FunctionalProvider<
          HealthConnectService,
          HealthConnectService,
          HealthConnectService
        >
    with $Provider<HealthConnectService> {
  HealthConnectServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthConnectServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthConnectServiceHash();

  @$internal
  @override
  $ProviderElement<HealthConnectService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HealthConnectService create(Ref ref) {
    return healthConnectService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthConnectService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthConnectService>(value),
    );
  }
}

String _$healthConnectServiceHash() =>
    r'431662a996b9b2053acd8204cda61bc291939930';
