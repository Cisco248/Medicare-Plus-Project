import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/dashboard/services/rag.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generationQuestion uses recorded values and N/A for missing fields', () {
    final service = RagService(client: Dio());
    final question = service.generationQuestion(
      HealthSummaryRequest.fromActivity(
        userId: 'u1',
        startTime: DateTime.utc(2026, 8, 23),
        endTime: DateTime.utc(2026, 8, 24),
        activity: ActivityModel(
          date: DateTime.utc(2026, 8, 23),
          steps: 4200,
          heartRate: const HeartRateSummary(averageBpm: 72),
        ),
      ),
      const PatientProfile(
        id: 'u1',
        name: 'Ada',
        email: 'ada@example.com',
        age: 44,
        gender: 'female',
        heightCm: 162,
      ),
    );

    expect(question, contains('Age: 44 years'));
    expect(question, contains('Gender: Female'));
    expect(question, contains('Height: 162.0 cm'));
    expect(question, contains('Heart Rate: 72.0 bpm'));
    expect(question, contains('Blood Pressure: N/A'));
    expect(question, contains('Steps: 4200 steps'));
    expect(question, isNot(contains('Instance of')));
  });
}
