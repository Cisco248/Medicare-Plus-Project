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
    extends $NotifierProvider<EDocModelNotifier, EDocPredictionModel> {
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
  Override overrideWithValue(EDocPredictionModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EDocPredictionModel>(value),
    );
  }
}

String _$eDocModelNotifierHash() => r'13dd1872944e758adf3e27acde38644fc0bd1deb';

abstract class _$EDocModelNotifier extends $Notifier<EDocPredictionModel> {
  EDocPredictionModel build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EDocPredictionModel, EDocPredictionModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EDocPredictionModel, EDocPredictionModel>,
              EDocPredictionModel,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
