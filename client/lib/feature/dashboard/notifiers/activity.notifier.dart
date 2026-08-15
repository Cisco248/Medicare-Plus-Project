import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/knowledge.state.model.dart';
import 'package:client/feature/dashboard/repository/activity_repository.dart';
import 'package:client/feature/dashboard/repository/knowledge.repository.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity.notifier.g.dart';

List<Permission> _stepsPermission = [Permission.steps.read];

List<Permission> _burnCaloryPermission = [Permission.totalCaloriesBurned.read];

@riverpod
class StepsActivityNotifier extends _$StepsActivityNotifier {
  @override
  Future<int> build() async {
    final records = await ref
        .watch(activityRepositoryProvider)
        .footStep(_stepsPermission);
    return records.fold<int>(0, (count, record) => count + record.count);
  }
}

@riverpod
class BurnCaloriesActivityNotifier extends _$BurnCaloriesActivityNotifier {
  @override
  Future<double> build() async {
    final records = await ref
        .watch(activityRepositoryProvider)
        .burnCalories(_burnCaloryPermission);
    return records.fold<double>(
      0.0,
      (count, record) => count + record.energyKilocalories,
    );
  }
}

@riverpod
class DailyActivityNotifier extends _$DailyActivityNotifier {
  @override
  Future<DailySummary> build() async {
    return ref.watch(activityRepositoryProvider).dailySummary();
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
@Riverpod(keepAlive: true)
class ActivityNotifier extends _$ActivityNotifier {
  ActivityRepository get _activityRepository =>
      ref.read(activityRepositoryProvider);

  KnowledgeRepository get _knowledgeRepository =>
      ref.read(knowledgeRepositoryProvider);

  @override
  KnowledgeState build() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    Future.microtask(loadHealthData);
    return KnowledgeState(
      phase: KnowledgePhase.loadingHealthData,
      periodStart: start,
      periodEnd: start.add(const Duration(days: 1)),
    );
  }

  /// Collects and normalizes health data for the current period.
  Future<void> loadHealthData() async {
    state = state.copyWith(
      phase: KnowledgePhase.loadingHealthData,
      errorMessage: null,
    );
    try {
      final result = await _activityRepository.collectActivity(
        startTime: state.periodStart,
        endTime: state.periodEnd,
      );
      switch (result.status) {
        case HealthAccessStatus.unavailable:
          state = state.copyWith(
            phase: KnowledgePhase.healthConnectUnavailable,
            activity: null,
          );
        case HealthAccessStatus.denied:
          state = state.copyWith(
            phase: KnowledgePhase.permissionRequired,
            activity: null,
            unavailableMetrics: result.deniedMetrics,
          );
        case HealthAccessStatus.partial:
        case HealthAccessStatus.granted:
          final activity = result.activity;
          final hasData = activity?.hasAnyData ?? false;
          state = state.copyWith(
            phase: hasData
                ? KnowledgePhase.healthDataReady
                : KnowledgePhase.noHealthData,
            activity: activity,
            unavailableMetrics: result.deniedMetrics,
          );
      }
    } on AppException catch (e) {
      state = state.copyWith(
        phase: KnowledgePhase.failure,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        phase: KnowledgePhase.failure,
        errorMessage: 'Reading your health data failed. Please try again.',
      );
    }
  }

  /// Re-collects health data and invalidates the cached summary.
  Future<void> refresh() async {
    state = state.copyWith(summary: null, summarySource: null);
    await loadHealthData();
  }

  /// Sends the collected health data to the RAG backend and stores the
  /// generated summary.
  ///
  /// Uses the cached summary when the health data has not changed, unless
  /// [force] is `true`.
  Future<void> generateSummary({bool force = false}) async {
    final activity = state.activity;
    if (activity == null || !activity.hasAnyData) return;

    if (!force && state.isSummaryUpToDate) {
      state = state.copyWith(phase: KnowledgePhase.summaryReady);
      return;
    }

    state = state.copyWith(
      phase: KnowledgePhase.generatingSummary,
      errorMessage: null,
    );
    try {
      final auth = ref.read(authenticationProvider).value;
      final summary = await _knowledgeRepository.generateSummary(
        activity: activity,
        startTime: state.periodStart,
        endTime: state.periodEnd,
        userId: auth?.data?.email,
        token: auth?.token,
      );
      state = state.copyWith(
        phase: KnowledgePhase.summaryReady,
        summary: summary,
        summarySource: activity,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        phase: KnowledgePhase.failure,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        phase: KnowledgePhase.failure,
        errorMessage: 'Generating your summary failed. Please try again.',
      );
    }
  }

  /// Launches the Health Connect permission flow and reloads afterwards.
  Future<void> requestPermissions() async {
    state = state.copyWith(
      phase: KnowledgePhase.loadingHealthData,
      errorMessage: null,
    );
    try {
      await _activityRepository.requestPermissions();
    } on AppException catch (e) {
      state = state.copyWith(
        phase: KnowledgePhase.failure,
        errorMessage: e.message,
      );
      return;
    } catch (_) {
      state = state.copyWith(
        phase: KnowledgePhase.failure,
        errorMessage: 'Requesting Health Connect access failed.',
      );
      return;
    }
    await loadHealthData();
  }

  /// Changes the collection period and re-collects, invalidating the cache.
  Future<void> changePeriod(DateTime startTime, DateTime endTime) async {
    state = state.copyWith(
      periodStart: startTime,
      periodEnd: endTime,
      summary: null,
      summarySource: null,
    );
    await loadHealthData();
  }

  /// Retries whichever step failed last.
  Future<void> retry() async {
    if (state.hasHealthData) {
      await generateSummary(force: true);
    } else {
      await loadHealthData();
    }
  }
}
