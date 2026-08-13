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
    r'2945570826a05e43f23c93158e762bfab156aced';

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
    r'3752d7e4a060c17871266437110b0ab6edc3c6be';

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
        isAutoDispose: true,
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
    r'7c769e1a112c4e168dce72dec301b53779244eb9';

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

/// Coordinates the Knowledge (health-summary) flow:
///
/// Health Connect → normalize → [ActivityModel] → summary request →
/// RAG API → AI summary → [KnowledgeState] consumed by `KnowledgeWidget`.
///
/// Kept alive so a generated summary is cached across widget rebuilds and
/// navigation; it is only regenerated on explicit request or when the
/// underlying health data changes.

@ProviderFor(ActivityNotifier)
final activityProvider = ActivityNotifierProvider._();

/// Coordinates the Knowledge (health-summary) flow:
///
/// Health Connect → normalize → [ActivityModel] → summary request →
/// RAG API → AI summary → [KnowledgeState] consumed by `KnowledgeWidget`.
///
/// Kept alive so a generated summary is cached across widget rebuilds and
/// navigation; it is only regenerated on explicit request or when the
/// underlying health data changes.
final class ActivityNotifierProvider
    extends $NotifierProvider<ActivityNotifier, KnowledgeState> {
  /// Coordinates the Knowledge (health-summary) flow:
  ///
  /// Health Connect → normalize → [ActivityModel] → summary request →
  /// RAG API → AI summary → [KnowledgeState] consumed by `KnowledgeWidget`.
  ///
  /// Kept alive so a generated summary is cached across widget rebuilds and
  /// navigation; it is only regenerated on explicit request or when the
  /// underlying health data changes.
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

String _$activityNotifierHash() => r'5e976a343c638e9a1afdae84f1105f06364a395e';

/// Coordinates the Knowledge (health-summary) flow:
///
/// Health Connect → normalize → [ActivityModel] → summary request →
/// RAG API → AI summary → [KnowledgeState] consumed by `KnowledgeWidget`.
///
/// Kept alive so a generated summary is cached across widget rebuilds and
/// navigation; it is only regenerated on explicit request or when the
/// underlying health data changes.

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
