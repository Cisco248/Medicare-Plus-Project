// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PrescriptionNotifier)
final prescriptionProvider = PrescriptionNotifierProvider._();

final class PrescriptionNotifierProvider
    extends
        $AsyncNotifierProvider<
          PrescriptionNotifier,
          Map<String, PrescriptionRecord>
        > {
  PrescriptionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prescriptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prescriptionNotifierHash();

  @$internal
  @override
  PrescriptionNotifier create() => PrescriptionNotifier();
}

String _$prescriptionNotifierHash() =>
    r'7fcabb1ae5678819484485ce552fff0ddfaaca9b';

abstract class _$PrescriptionNotifier
    extends $AsyncNotifier<Map<String, PrescriptionRecord>> {
  FutureOr<Map<String, PrescriptionRecord>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<String, PrescriptionRecord>>,
              Map<String, PrescriptionRecord>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, PrescriptionRecord>>,
                Map<String, PrescriptionRecord>
              >,
              AsyncValue<Map<String, PrescriptionRecord>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PrescriptionRec)
final prescriptionRecProvider = PrescriptionRecProvider._();

final class PrescriptionRecProvider
    extends
        $NotifierProvider<PrescriptionRec, Map<String, PrescriptionRecord>> {
  PrescriptionRecProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prescriptionRecProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prescriptionRecHash();

  @$internal
  @override
  PrescriptionRec create() => PrescriptionRec();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, PrescriptionRecord> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, PrescriptionRecord>>(
        value,
      ),
    );
  }
}

String _$prescriptionRecHash() => r'1396b3f408dff2d094e214ffd9f89a61685c47b8';

abstract class _$PrescriptionRec
    extends $Notifier<Map<String, PrescriptionRecord>> {
  Map<String, PrescriptionRecord> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, PrescriptionRecord>,
              Map<String, PrescriptionRecord>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, PrescriptionRecord>,
                Map<String, PrescriptionRecord>
              >,
              Map<String, PrescriptionRecord>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
