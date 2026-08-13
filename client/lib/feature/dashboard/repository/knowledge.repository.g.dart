// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(knowledgeRepository)
final knowledgeRepositoryProvider = KnowledgeRepositoryProvider._();

final class KnowledgeRepositoryProvider
    extends
        $FunctionalProvider<
          KnowledgeRepository,
          KnowledgeRepository,
          KnowledgeRepository
        >
    with $Provider<KnowledgeRepository> {
  KnowledgeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeRepositoryHash();

  @$internal
  @override
  $ProviderElement<KnowledgeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KnowledgeRepository create(Ref ref) {
    return knowledgeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KnowledgeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KnowledgeRepository>(value),
    );
  }
}

String _$knowledgeRepositoryHash() =>
    r'5858ad5388afb86da11da73ad173c1af2a9f43f1';
