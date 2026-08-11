// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PharmacyNotifier)
final pharmacyProvider = PharmacyNotifierProvider._();

final class PharmacyNotifierProvider
    extends $AsyncNotifierProvider<PharmacyNotifier, List<MedicineModel>> {
  PharmacyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pharmacyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pharmacyNotifierHash();

  @$internal
  @override
  PharmacyNotifier create() => PharmacyNotifier();
}

String _$pharmacyNotifierHash() => r'c0972d73cfb1e60d5d5305f78b615df3044b3809';

abstract class _$PharmacyNotifier extends $AsyncNotifier<List<MedicineModel>> {
  FutureOr<List<MedicineModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<MedicineModel>>, List<MedicineModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MedicineModel>>, List<MedicineModel>>,
              AsyncValue<List<MedicineModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
