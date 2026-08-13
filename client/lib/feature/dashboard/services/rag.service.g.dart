// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rag.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ragService)
final ragServiceProvider = RagServiceProvider._();

final class RagServiceProvider
    extends $FunctionalProvider<RagService, RagService, RagService>
    with $Provider<RagService> {
  RagServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ragServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ragServiceHash();

  @$internal
  @override
  $ProviderElement<RagService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RagService create(Ref ref) {
    return ragService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RagService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RagService>(value),
    );
  }
}

String _$ragServiceHash() => r'21f305b235115f7bc1e1a5620356307e171fa395';
