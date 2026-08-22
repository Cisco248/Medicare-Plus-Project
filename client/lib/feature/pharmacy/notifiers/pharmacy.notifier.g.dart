// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PharmacyCatalogNotifier)
final pharmacyCatalogProvider = PharmacyCatalogNotifierProvider._();

final class PharmacyCatalogNotifierProvider
    extends
        $AsyncNotifierProvider<PharmacyCatalogNotifier, List<PharmacyProduct>> {
  PharmacyCatalogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pharmacyCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pharmacyCatalogNotifierHash();

  @$internal
  @override
  PharmacyCatalogNotifier create() => PharmacyCatalogNotifier();
}

String _$pharmacyCatalogNotifierHash() =>
    r'09846ec74a92e3c19625cf42281edfa5ad66238d';

abstract class _$PharmacyCatalogNotifier
    extends $AsyncNotifier<List<PharmacyProduct>> {
  FutureOr<List<PharmacyProduct>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<PharmacyProduct>>, List<PharmacyProduct>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PharmacyProduct>>,
                List<PharmacyProduct>
              >,
              AsyncValue<List<PharmacyProduct>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PharmacyQueryNotifier)
final pharmacyQueryProvider = PharmacyQueryNotifierProvider._();

final class PharmacyQueryNotifierProvider
    extends $NotifierProvider<PharmacyQueryNotifier, PharmacyQuery> {
  PharmacyQueryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pharmacyQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pharmacyQueryNotifierHash();

  @$internal
  @override
  PharmacyQueryNotifier create() => PharmacyQueryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PharmacyQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PharmacyQuery>(value),
    );
  }
}

String _$pharmacyQueryNotifierHash() =>
    r'4f36bf573f6c73212862f92dcdf25facccd560cc';

abstract class _$PharmacyQueryNotifier extends $Notifier<PharmacyQuery> {
  PharmacyQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PharmacyQuery, PharmacyQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PharmacyQuery, PharmacyQuery>,
              PharmacyQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RecentProductsNotifier)
final recentProductsProvider = RecentProductsNotifierProvider._();

final class RecentProductsNotifierProvider
    extends $AsyncNotifierProvider<RecentProductsNotifier, List<String>> {
  RecentProductsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentProductsNotifierHash();

  @$internal
  @override
  RecentProductsNotifier create() => RecentProductsNotifier();
}

String _$recentProductsNotifierHash() =>
    r'62b0f1eb9d5e7a0ed9d7571f3e1ec0d52178fcc9';

abstract class _$RecentProductsNotifier extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
