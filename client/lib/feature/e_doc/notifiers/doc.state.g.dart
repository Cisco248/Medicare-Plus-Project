// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc.state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DocStateNotifier)
final docStateProvider = DocStateNotifierProvider._();

final class DocStateNotifierProvider
    extends $NotifierProvider<DocStateNotifier, DocState> {
  DocStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'docStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$docStateNotifierHash();

  @$internal
  @override
  DocStateNotifier create() => DocStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocState>(value),
    );
  }
}

String _$docStateNotifierHash() => r'f3376270af3af77e49559e1b0a59680100e91ec9';

abstract class _$DocStateNotifier extends $Notifier<DocState> {
  DocState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DocState, DocState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DocState, DocState>,
              DocState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
