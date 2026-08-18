// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EDocAssessmentNotifier)
final eDocAssessmentProvider = EDocAssessmentNotifierProvider._();

final class EDocAssessmentNotifierProvider
    extends $NotifierProvider<EDocAssessmentNotifier, EDocAssessmentState> {
  EDocAssessmentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eDocAssessmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eDocAssessmentNotifierHash();

  @$internal
  @override
  EDocAssessmentNotifier create() => EDocAssessmentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EDocAssessmentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EDocAssessmentState>(value),
    );
  }
}

String _$eDocAssessmentNotifierHash() =>
    r'2932a014da6919a18862a4db12155392a17007c1';

abstract class _$EDocAssessmentNotifier extends $Notifier<EDocAssessmentState> {
  EDocAssessmentState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EDocAssessmentState, EDocAssessmentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EDocAssessmentState, EDocAssessmentState>,
              EDocAssessmentState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
