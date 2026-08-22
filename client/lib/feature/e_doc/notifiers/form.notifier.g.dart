// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EDocModelNotifier)
final eDocModelProvider = EDocModelNotifierProvider._();

final class EDocModelNotifierProvider
    extends $NotifierProvider<EDocModelNotifier, DocModel> {
  EDocModelNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eDocModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eDocModelNotifierHash();

  @$internal
  @override
  EDocModelNotifier create() => EDocModelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocModel>(value),
    );
  }
}

String _$eDocModelNotifierHash() => r'4fa55abf78eab57a936ba1357a379eb302b04b74';

abstract class _$EDocModelNotifier extends $Notifier<DocModel> {
  DocModel build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DocModel, DocModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DocModel, DocModel>,
              DocModel,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
