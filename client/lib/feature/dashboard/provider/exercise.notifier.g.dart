// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CardioExerciseNotifier)
final cardioExerciseProvider = CardioExerciseNotifierProvider._();

final class CardioExerciseNotifierProvider
    extends $NotifierProvider<CardioExerciseNotifier, List<String>> {
  CardioExerciseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cardioExerciseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cardioExerciseNotifierHash();

  @$internal
  @override
  CardioExerciseNotifier create() => CardioExerciseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$cardioExerciseNotifierHash() =>
    r'50a01ab8abecce85fa6121b01a34b7647a3f4c6c';

abstract class _$CardioExerciseNotifier extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(WarmUpExerciseNotifier)
final warmUpExerciseProvider = WarmUpExerciseNotifierProvider._();

final class WarmUpExerciseNotifierProvider
    extends $NotifierProvider<WarmUpExerciseNotifier, List<String>> {
  WarmUpExerciseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'warmUpExerciseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$warmUpExerciseNotifierHash();

  @$internal
  @override
  WarmUpExerciseNotifier create() => WarmUpExerciseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$warmUpExerciseNotifierHash() =>
    r'd3046dc761877cd2cd654327bb6b3f1f625462b1';

abstract class _$WarmUpExerciseNotifier extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
