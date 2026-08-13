import 'package:client/feature/auth/models/auth.model.dart';
import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary_response.model.dart';
import 'package:client/feature/dashboard/repository/activity_repository.dart';
import 'package:client/feature/dashboard/repository/knowledge.repository.dart';
import 'package:client/feature/dashboard/services/health_connect.service.dart';
import 'package:client/feature/dashboard/services/rag.service.dart';
import 'package:dio/dio.dart';

/// Hand-rolled fakes (the project has no mocking library).
class FakeActivityRepository extends ActivityRepository {
  FakeActivityRepository() : super(service: HealthConnectService());

  Future<HealthDataResult> Function()? onCollect;
  bool requestPermissionsResult = true;
  int collectCalls = 0;
  int requestPermissionCalls = 0;

  @override
  Future<HealthDataResult> collectActivity({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    collectCalls++;
    return onCollect!();
  }

  @override
  Future<bool> requestPermissions() async {
    requestPermissionCalls++;
    return requestPermissionsResult;
  }

  @override
  Future<void> openPermissionSettings() async {}
}

class FakeKnowledgeRepository extends KnowledgeRepository {
  FakeKnowledgeRepository() : super(ragService: RagService(client: Dio()));

  Future<HealthSummaryResponse> Function()? onGenerate;
  int generateCalls = 0;

  @override
  Future<HealthSummaryResponse> generateSummary({
    required ActivityModel activity,
    required DateTime startTime,
    required DateTime endTime,
    String? userId,
    String? token,
  }) {
    generateCalls++;
    return onGenerate!();
  }
}

class FakeAuthenticationNotifier extends AuthenticationNotifier {
  @override
  Future<AuthStatus> build() async =>
      const AuthStatus(state: AuthMode.unauthenticated);
}

ActivityModel sampleActivity({DateTime? date}) => ActivityModel(
  date: date ?? DateTime(2026, 8, 14),
  steps: 5400,
  distanceMeters: 3800.5,
  activeCalories: 320.0,
  totalCalories: 1900.0,
  heartRate: const HeartRateSummary(
    averageBpm: 72.5,
    minBpm: 55,
    maxBpm: 140,
    restingBpm: 58.0,
  ),
  sleep: const SleepSummary(totalMinutes: 420, sessionCount: 1),
);

HealthSummaryResponse sampleSummary() => HealthSummaryResponse(
  summary: 'Your activity level has been steady today.',
  recommendations: const ['Stay hydrated.'],
  disclaimer: 'Informational only.',
  generatedAt: DateTime.utc(2026, 8, 14, 12),
);
