// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diabetes.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diabetesRepository)
final diabetesRepositoryProvider = DiabetesRepositoryProvider._();

final class DiabetesRepositoryProvider
    extends
        $FunctionalProvider<
          DiabetesRepository,
          DiabetesRepository,
          DiabetesRepository
        >
    with $Provider<DiabetesRepository> {
  DiabetesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diabetesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diabetesRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiabetesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiabetesRepository create(Ref ref) {
    return diabetesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiabetesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiabetesRepository>(value),
    );
  }
}

String _$diabetesRepositoryHash() =>
    r'50ebf3a9874e7553f5ebb93298dca536bf1e7985';
