// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KnowledgeNotifier)
final knowledgeProvider = KnowledgeNotifierProvider._();

final class KnowledgeNotifierProvider
    extends $NotifierProvider<KnowledgeNotifier, String> {
  KnowledgeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeNotifierHash();

  @$internal
  @override
  KnowledgeNotifier create() => KnowledgeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$knowledgeNotifierHash() => r'48d9853671115bea3da2dfd34e890b1178581082';

abstract class _$KnowledgeNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
