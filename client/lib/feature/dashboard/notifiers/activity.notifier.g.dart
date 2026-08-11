// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StepsActivityNotifier)
final stepsActivityProvider = StepsActivityNotifierProvider._();

final class StepsActivityNotifierProvider
    extends $AsyncNotifierProvider<StepsActivityNotifier, int> {
  StepsActivityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stepsActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stepsActivityNotifierHash();

  @$internal
  @override
  StepsActivityNotifier create() => StepsActivityNotifier();
}

String _$stepsActivityNotifierHash() =>
    r'd9d9f578c9d21977e408ccac4c80ae0af40823da';

abstract class _$StepsActivityNotifier extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BurnCaloriesActivityNotifier)
final burnCaloriesActivityProvider = BurnCaloriesActivityNotifierProvider._();

final class BurnCaloriesActivityNotifierProvider
    extends $AsyncNotifierProvider<BurnCaloriesActivityNotifier, double> {
  BurnCaloriesActivityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'burnCaloriesActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$burnCaloriesActivityNotifierHash();

  @$internal
  @override
  BurnCaloriesActivityNotifier create() => BurnCaloriesActivityNotifier();
}

String _$burnCaloriesActivityNotifierHash() =>
    r'742315e20c871baeb213c17b435ecf8038d6596d';

abstract class _$BurnCaloriesActivityNotifier extends $AsyncNotifier<double> {
  FutureOr<double> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<double>, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<double>, double>,
              AsyncValue<double>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BloodPressureActivityNotifier)
final bloodPressureActivityProvider = BloodPressureActivityNotifierProvider._();

final class BloodPressureActivityNotifierProvider
    extends
        $AsyncNotifierProvider<
          BloodPressureActivityNotifier,
          BloodPressureModel?
        > {
  BloodPressureActivityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloodPressureActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bloodPressureActivityNotifierHash();

  @$internal
  @override
  BloodPressureActivityNotifier create() => BloodPressureActivityNotifier();
}

String _$bloodPressureActivityNotifierHash() =>
    r'6cc93285217f942835bdf612dbc4e21a7abde284';

abstract class _$BloodPressureActivityNotifier
    extends $AsyncNotifier<BloodPressureModel?> {
  FutureOr<BloodPressureModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<BloodPressureModel?>, BloodPressureModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BloodPressureModel?>, BloodPressureModel?>,
              AsyncValue<BloodPressureModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
