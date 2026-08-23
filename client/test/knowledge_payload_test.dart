import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('knowledge payload uses RAG snake_case activity fields', () {
    final request = HealthSummaryRequest.fromActivity(
      userId: 'u1',
      startTime: DateTime.utc(2026, 8, 23),
      endTime: DateTime.utc(2026, 8, 24),
      activity: ActivityModel(
        date: DateTime.utc(2026, 8, 23),
        steps: 4200,
        distanceMeters: 3100,
        sleep: const SleepSummary(totalMinutes: 390, sessionCount: 1),
        bloodPressure: const BloodPressureSummary(
          systolicMmHg: 128,
          diastolicMmHg: 82,
        ),
        workouts: [
          WorkoutSummary(
            type: 'walking',
            startTime: DateTime.utc(2026, 8, 23, 6),
            endTime: DateTime.utc(2026, 8, 23, 6, 30),
            durationMinutes: 30,
          ),
        ],
      ),
    );

    final json = knowledgeSummaryJson(request);
    final activities = json['activities'] as Map<String, dynamic>;
    final sleep = activities['sleep'] as Map<String, dynamic>;
    final pressure = activities['blood_pressure'] as Map<String, dynamic>;
    final workout = (activities['workouts'] as List).single as Map<String, dynamic>;

    expect(json['user_id'], 'u1');
    expect(json['period'], containsPair('timezone_offset', isNotNull));
    expect(activities['distance_meters'], 3100);
    expect(sleep['total_minutes'], 390);
    expect(sleep['session_count'], 1);
    expect(pressure['systolic_mm_hg'], 128);
    expect(workout['start_time'], '2026-08-23T06:00:00.000Z');
    expect(workout.containsKey('startTime'), isFalse);
    expect(activities.containsKey('distanceMeters'), isFalse);
  });

  test('knowledge payload matches the RAG request template without invented zeros', () {
    final request = HealthSummaryRequest.fromActivity(
      userId: 'u1',
      startTime: DateTime.utc(2026, 8, 23),
      endTime: DateTime.utc(2026, 8, 24),
      activity: ActivityModel(
        date: DateTime.utc(2026, 8, 23),
        steps: 4200,
      ),
    );
    final json = knowledgeSummaryJson(
      request,
      question: 'Generate a health summary',
      user: const PatientProfile(
        id: 'u1',
        name: 'Ada',
        email: 'ada@example.com',
        age: 44,
        gender: 'Female',
        heightCm: 162,
      ),
    );

    expect(json.keys, containsAll(['question', 'user_id', 'period', 'activities']));
    expect(json['age'], 44);
    expect(json['gender'], 'female');
    expect(json['height_cm'], 162);
    expect(json.containsKey('weight_kg'), isFalse);
    expect((json['activities'] as Map)['steps'], 4200);
    expect((json['activities'] as Map).containsKey('heart_rate'), isFalse);
    expect((json['period'] as Map)['start'], '2026-08-23T00:00:00.000Z');
  });
}
