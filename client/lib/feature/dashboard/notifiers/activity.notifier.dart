import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/network/dio_client.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/knowledge.state.model.dart';
import 'package:client/feature/dashboard/repository/activity_repository.dart';
import 'package:client/feature/dashboard/repository/knowledge.repository.dart';
import 'package:client/feature/dashboard/services/health_connect.service.dart';
import 'package:client/feature/dashboard/services/rag.service.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity.notifier.g.dart';

final List<Permission> _stepsPermission = [Permission.steps.read];
final List<Permission> _burnCaloryPermission = [
  Permission.totalCaloriesBurned.read,
];
final List<Permission> _heightPermission = [Permission.height.read];
final List<Permission> _sleepPermission = [Permission.steps.read];

final _activityRepository = ActivityRepository(service: HealthConnectService());
final _knowledgeRepository = KnowledgeRepository(
  ragService: RagService(client: ragClient()),
);

@riverpod
class StepsActivityNotifier extends _$StepsActivityNotifier {
  @override
  Future<int> build() async {
    final records = await _activityRepository.footStep(_stepsPermission);
    return records.fold<int>(0, (count, record) => count + record.count);
  }
}

@riverpod
class BurnCaloriesActivityNotifier extends _$BurnCaloriesActivityNotifier {
  @override
  Future<double> build() async {
    final records = await _activityRepository.burnCalories(
      _burnCaloryPermission,
    );
    return records.fold<double>(
      0.0,
      (total, record) => total + record.energyKilocalories,
    );
  }
}

@Riverpod(keepAlive: true)
class DailyActivityNotifier extends _$DailyActivityNotifier {
  @override
  Future<DailySummary> build() async {
    final res = await _activityRepository.dailySummary();
    print(res.toString());
    return res;
  }
}

@riverpod
class BodyHeightNotifier extends _$BodyHeightNotifier {
  @override
  Future<double> build() async {
    final records = await _activityRepository.bodyHeight(_heightPermission);
    return records.isEmpty ? 0.0 : records.last.heightMeters;
  }
}

@riverpod
class SleepHoursNotifier extends _$SleepHoursNotifier {
  @override
  Future<double> build() async {
    final records = await _activityRepository.sleepHour(_sleepPermission);
    return records.isEmpty
        ? 0.0
        : double.parse(records.last.duration.toString());
  }
}

@Riverpod(keepAlive: true)
class ActivityNotifier extends _$ActivityNotifier {
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

  Future<void> refresh() async {
    state = state.copyWith(summary: null, summarySource: null);
    await loadHealthData();
  }

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
        token: auth?.data?.token,
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

  Future<void> changePeriod(DateTime startTime, DateTime endTime) async {
    state = state.copyWith(
      periodStart: startTime,
      periodEnd: endTime,
      summary: null,
      summarySource: null,
    );
    await loadHealthData();
  }

  Future<void> retry() async {
    if (state.hasHealthData) {
      await generateSummary(force: true);
    } else {
      await loadHealthData();
    }
  }
}
