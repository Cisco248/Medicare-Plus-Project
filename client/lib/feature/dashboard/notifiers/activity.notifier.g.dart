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
    r'3f38f47a4b79773d79cd20b70d3c407288bf23e6';

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
    r'465927ea06c16f93dca76fcb6c07306860c2f322';

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

@ProviderFor(DailyActivityNotifier)
final dailyActivityProvider = DailyActivityNotifierProvider._();

final class DailyActivityNotifierProvider
    extends $AsyncNotifierProvider<DailyActivityNotifier, DailySummary> {
  DailyActivityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyActivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyActivityNotifierHash();

  @$internal
  @override
  DailyActivityNotifier create() => DailyActivityNotifier();
}

String _$dailyActivityNotifierHash() =>
    r'617dbf5b0cd6880e80245d3e7d3dff4a643f31ce';

abstract class _$DailyActivityNotifier extends $AsyncNotifier<DailySummary> {
  FutureOr<DailySummary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DailySummary>, DailySummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DailySummary>, DailySummary>,
              AsyncValue<DailySummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BodyHeightNotifier)
final bodyHeightProvider = BodyHeightNotifierProvider._();

final class BodyHeightNotifierProvider
    extends $AsyncNotifierProvider<BodyHeightNotifier, double> {
  BodyHeightNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyHeightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyHeightNotifierHash();

  @$internal
  @override
  BodyHeightNotifier create() => BodyHeightNotifier();
}

String _$bodyHeightNotifierHash() =>
    r'3f7d8f7c9f38aa200b7dad5090bdf722cffa59f9';

abstract class _$BodyHeightNotifier extends $AsyncNotifier<double> {
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

@ProviderFor(SleepHoursNotifier)
final sleepHoursProvider = SleepHoursNotifierProvider._();

final class SleepHoursNotifierProvider
    extends $AsyncNotifierProvider<SleepHoursNotifier, double> {
  SleepHoursNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepHoursProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepHoursNotifierHash();

  @$internal
  @override
  SleepHoursNotifier create() => SleepHoursNotifier();
}

String _$sleepHoursNotifierHash() =>
    r'6334370ef428025f1780f780baec5f91eb3da037';

abstract class _$SleepHoursNotifier extends $AsyncNotifier<double> {
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

@ProviderFor(ActivityNotifier)
final activityProvider = ActivityNotifierProvider._();

final class ActivityNotifierProvider
    extends $NotifierProvider<ActivityNotifier, KnowledgeState> {
  ActivityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityNotifierHash();

  @$internal
  @override
  ActivityNotifier create() => ActivityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KnowledgeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KnowledgeState>(value),
    );
  }
}

String _$activityNotifierHash() => r'3ff6403875314e9c84a8c89301d83e8566ee90d7';

abstract class _$ActivityNotifier extends $Notifier<KnowledgeState> {
  KnowledgeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<KnowledgeState, KnowledgeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KnowledgeState, KnowledgeState>,
              KnowledgeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
