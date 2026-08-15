import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/health_summary_request.model.dart';
import 'package:client/feature/dashboard/models/health_summary_response.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityModel', () {
    test('serializes all metrics to snake_case JSON', () {
      final model = ActivityModel(
        date: DateTime.utc(2026, 8, 14),
        steps: 1200,
        distanceMeters: 950.5,
        activeCalories: 210.0,
        totalCalories: 1800.0,
        heartRate: const HeartRateSummary(
          averageBpm: 71.0,
          minBpm: 52,
          maxBpm: 133,
          restingBpm: 56.0,
        ),
        sleep: const SleepSummary(totalMinutes: 400, sessionCount: 2),
        workouts: [
          WorkoutSummary(
            type: 'RUNNING',
            startTime: DateTime.utc(2026, 8, 14, 6),
            endTime: DateTime.utc(2026, 8, 14, 6, 30),
            durationMinutes: 30,
          ),
        ],
        weightKilograms: 70.5,
        heightMeters: 1.75,
        bloodPressure: const BloodPressureSummary(
          systolicMmHg: 118,
          diastolicMmHg: 76,
        ),
        bloodGlucoseMmolPerLiter: 5.2,
        oxygenSaturationPercent: 98.0,
      );

      final json = model.toJson();

      expect(json['steps'], 1200);
      expect(json['distance_meters'], 950.5);
      expect(json['active_calories'], 210.0);
      expect(json['total_calories'], 1800.0);
      expect(json['heart_rate'], {
        'average_bpm': 71.0,
        'min_bpm': 52,
        'max_bpm': 133,
        'resting_bpm': 56.0,
      });
      expect(json['sleep'], {'total_minutes': 400, 'session_count': 2});
      expect((json['workouts'] as List).single, {
        'type': 'RUNNING',
        'title': null,
        'start_time': '2026-08-14T06:00:00.000Z',
        'end_time': '2026-08-14T06:30:00.000Z',
        'duration_minutes': 30,
      });
      expect(json['weight_kilograms'], 70.5);
      expect(json['height_meters'], 1.75);
      expect(json['blood_glucose_mmol_per_liter'], 5.2);
      expect(json['oxygen_saturation_percent'], 98.0);
    });

    test('round-trips through JSON', () {
      final model = ActivityModel(
        date: DateTime.utc(2026, 8, 14),
        steps: 500,
        heartRate: const HeartRateSummary(averageBpm: 65.0),
      );

      final restored = ActivityModel.fromJson(model.toJson());

      expect(restored, model);
    });

    test('missing metrics stay null and are never zero', () {
      final restored = ActivityModel.fromJson({
        'date': '2026-08-14T00:00:00.000Z',
        'steps': null,
        'workouts': <Object?>[],
      });

      expect(restored.steps, isNull);
      expect(restored.distanceMeters, isNull);
      expect(restored.heartRate, isNull);
      expect(restored.sleep, isNull);
      expect(restored.workouts, isEmpty);
      expect(restored.hasAnyData, isFalse);
    });

    test('hasAnyData is true when a single metric is present', () {
      final model = ActivityModel(date: DateTime.utc(2026, 8, 14), steps: 1);
      expect(model.hasAnyData, isTrue);
    });
  });

  group('HealthSummaryRequest', () {
    test('fromActivity builds the backend contract payload', () {
      final activity = ActivityModel(
        date: DateTime.utc(2026, 8, 14),
        steps: 100,
      );
      final request = HealthSummaryRequest.fromActivity(
        activity: activity,
        startTime: DateTime.utc(2026, 8, 14),
        endTime: DateTime.utc(2026, 8, 15),
        userId: 'patient@example.com',
      );

      final json = request.toJson();

      expect(json['user_id'], 'patient@example.com');
      final period = json['period'] as Map<String, Object?>;
      expect(period['start'], '2026-08-14T00:00:00.000Z');
      expect(period['end'], '2026-08-15T00:00:00.000Z');
      expect(period['timezone_offset'], '+00:00');
      final activities = json['activities'] as Map<String, Object?>;
      expect(activities['steps'], 100);
      expect(activities['distance_meters'], isNull);
    });
  });

  group('HealthSummaryResponse', () {
    test('parses the backend contract payload', () {
      final response = HealthSummaryResponse.fromJson({
        'summary': 'Your activity level has been steady.',
        'recommendations': ['Keep walking daily.'],
        'disclaimer': 'Not a diagnosis.',
        'generated_at': '2026-08-14T12:00:00Z',
      });

      expect(response.summary, 'Your activity level has been steady.');
      expect(response.recommendations, ['Keep walking daily.']);
      expect(response.disclaimer, 'Not a diagnosis.');
      expect(response.generatedAt, DateTime.utc(2026, 8, 14, 12));
    });

    test('parses a minimal payload with defaults', () {
      final response = HealthSummaryResponse.fromJson({'summary': 'ok'});

      expect(response.summary, 'ok');
      expect(response.recommendations, isEmpty);
      expect(response.disclaimer, isNull);
      expect(response.generatedAt, isNull);
    });
  });
}
