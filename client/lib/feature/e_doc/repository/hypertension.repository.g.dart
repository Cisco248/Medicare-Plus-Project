// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypertension.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hypertensionRepository)
final hypertensionRepositoryProvider = HypertensionRepositoryProvider._();

final class HypertensionRepositoryProvider
    extends
        $FunctionalProvider<
          HypertensionRepository,
          HypertensionRepository,
          HypertensionRepository
        >
    with $Provider<HypertensionRepository> {
  HypertensionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hypertensionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hypertensionRepositoryHash();

  @$internal
  @override
  $ProviderElement<HypertensionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HypertensionRepository create(Ref ref) {
    return hypertensionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HypertensionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HypertensionRepository>(value),
    );
  }
}

String _$hypertensionRepositoryHash() =>
    r'db40ae8ba27a78d54aa3056ce7cd61982b259f39';
