import 'package:client/feature/dashboard/services/health_aggregator.dart';
import 'package:flutter_health_connect/app.dart';
import 'package:flutter_test/flutter_test.dart';

StepsRecord steps(String id, int count, DateTime start, DateTime end) =>
    StepsRecord(id: id, startTime: start, endTime: end, count: count);

void main() {
  final dayStart = DateTime.utc(2026, 8, 14);
  final dayEnd = DateTime.utc(2026, 8, 15);

  group('sumSteps', () {
    test('sums multiple records', () {
      final total = HealthAggregator.sumSteps([
        steps('a', 100, dayStart, dayStart.add(const Duration(hours: 1))),
        steps(
          'b',
          250,
          dayStart.add(const Duration(hours: 2)),
          dayStart.add(const Duration(hours: 3)),
        ),
      ]);
      expect(total, 350);
    });

    test('does not double-count duplicate record IDs', () {
      final record = steps(
        'same',
        100,
        dayStart,
        dayStart.add(const Duration(hours: 1)),
      );
      expect(HealthAggregator.sumSteps([record, record]), 100);
    });

    test('returns null for empty data (never zero)', () {
      expect(HealthAggregator.sumSteps(const []), isNull);
    });
  });

  group('calories', () {
    test('sums multiple active-calorie records', () {
      final total = HealthAggregator.sumActiveCalories([
        ActiveCaloriesBurnedRecord(
          id: 'a',
          startTime: dayStart,
          endTime: dayStart.add(const Duration(hours: 1)),
          energyKilocalories: 120.5,
        ),
        ActiveCaloriesBurnedRecord(
          id: 'b',
          startTime: dayStart.add(const Duration(hours: 2)),
          endTime: dayStart.add(const Duration(hours: 3)),
          energyKilocalories: 79.5,
        ),
      ]);
      expect(total, 200.0);
    });

    test('returns null when there are no records', () {
      expect(HealthAggregator.sumTotalCalories(const []), isNull);
    });
  });

  group('summarizeHeartRate', () {
    test('computes average, min and max across samples', () {
      final summary = HealthAggregator.summarizeHeartRate(
        [
          HeartRateRecord(
            id: 'hr1',
            startTime: dayStart,
            endTime: dayStart.add(const Duration(minutes: 5)),
            samples: [
              HeartRateSample(time: dayStart, beatsPerMinute: 60),
              HeartRateSample(time: dayStart, beatsPerMinute: 80),
            ],
          ),
          HeartRateRecord(
            id: 'hr2',
            startTime: dayStart.add(const Duration(hours: 1)),
            endTime: dayStart.add(const Duration(hours: 1, minutes: 5)),
            samples: [
              HeartRateSample(
                time: dayStart.add(const Duration(hours: 1)),
                beatsPerMinute: 100,
              ),
            ],
          ),
        ],
        [
          RestingHeartRateRecord(
            id: 'r1',
            startTime: dayStart,
            endTime: dayStart,
            beatsPerMinute: 55,
          ),
          RestingHeartRateRecord(
            id: 'r2',
            startTime: dayStart,
            endTime: dayStart,
            beatsPerMinute: 65,
          ),
        ],
      );

      expect(summary, isNotNull);
      expect(summary!.averageBpm, 80.0);
      expect(summary.minBpm, 60);
      expect(summary.maxBpm, 100);
      expect(summary.restingBpm, 60.0);
    });

    test('returns null with no heart-rate data at all', () {
      expect(HealthAggregator.summarizeHeartRate(const [], const []), isNull);
    });

    test('handles resting-only data', () {
      final summary = HealthAggregator.summarizeHeartRate(const [], [
        RestingHeartRateRecord(
          id: 'r1',
          startTime: dayStart,
          endTime: dayStart,
          beatsPerMinute: 58,
        ),
      ]);
      expect(summary!.averageBpm, isNull);
      expect(summary.restingBpm, 58.0);
    });
  });

  group('summarizeSleep', () {
    test('merges overlapping sessions so minutes are not double-counted', () {
      final summary = HealthAggregator.summarizeSleep([
        SleepSessionRecord(
          id: 's1',
          startTime: DateTime.utc(2026, 8, 13, 22),
          endTime: DateTime.utc(2026, 8, 13, 23),
        ),
        SleepSessionRecord(
          id: 's2',
          startTime: DateTime.utc(2026, 8, 13, 22, 30),
          endTime: DateTime.utc(2026, 8, 13, 23, 30),
        ),
      ]);

      expect(summary!.totalMinutes, 90);
      expect(summary.sessionCount, 2);
    });

    test('sums disjoint sessions', () {
      final summary = HealthAggregator.summarizeSleep([
        SleepSessionRecord(
          id: 's1',
          startTime: DateTime.utc(2026, 8, 13, 22),
          endTime: DateTime.utc(2026, 8, 13, 23),
        ),
        SleepSessionRecord(
          id: 's2',
          startTime: DateTime.utc(2026, 8, 14, 1),
          endTime: DateTime.utc(2026, 8, 14, 2, 30),
        ),
      ]);

      expect(summary!.totalMinutes, 60 + 90);
    });

    test('returns null for empty data', () {
      expect(HealthAggregator.summarizeSleep(const []), isNull);
    });
  });

  group('summarizeWorkouts', () {
    test('normalizes exercise sessions sorted by start time', () {
      final workouts = HealthAggregator.summarizeWorkouts([
        ExerciseSessionRecord(
          id: 'w2',
          startTime: DateTime.utc(2026, 8, 14, 18),
          endTime: DateTime.utc(2026, 8, 14, 18, 45),
          exerciseType: 'BIKING',
        ),
        ExerciseSessionRecord(
          id: 'w1',
          startTime: DateTime.utc(2026, 8, 14, 6),
          endTime: DateTime.utc(2026, 8, 14, 6, 30),
          exerciseType: 'RUNNING',
          title: 'Morning run',
        ),
      ]);

      expect(workouts, hasLength(2));
      expect(workouts.first.type, 'RUNNING');
      expect(workouts.first.title, 'Morning run');
      expect(workouts.first.durationMinutes, 30);
      expect(workouts.last.type, 'BIKING');
      expect(workouts.last.durationMinutes, 45);
    });

    test('returns an empty list for no sessions', () {
      expect(HealthAggregator.summarizeWorkouts(const []), isEmpty);
    });
  });

  group('latest measurements', () {
    test('picks the most recent weight', () {
      final weight = HealthAggregator.latestWeightKilograms([
        WeightRecord(
          id: 'w1',
          startTime: dayStart,
          endTime: dayStart,
          weightKilograms: 70,
        ),
        WeightRecord(
          id: 'w2',
          startTime: dayStart.add(const Duration(hours: 8)),
          endTime: dayStart.add(const Duration(hours: 8)),
          weightKilograms: 70.6,
        ),
      ]);
      expect(weight, 70.6);
    });

    test('picks the most recent blood pressure', () {
      final bp = HealthAggregator.latestBloodPressure([
        BloodPressureRecord(
          id: 'b1',
          startTime: dayStart,
          endTime: dayStart,
          systolicMmHg: 120,
          diastolicMmHg: 80,
        ),
        BloodPressureRecord(
          id: 'b2',
          startTime: dayStart.add(const Duration(hours: 6)),
          endTime: dayStart.add(const Duration(hours: 6)),
          systolicMmHg: 116,
          diastolicMmHg: 74,
        ),
      ]);
      expect(bp!.systolicMmHg, 116);
      expect(bp.diastolicMmHg, 74);
    });

    test('returns null for missing data', () {
      expect(HealthAggregator.latestWeightKilograms(const []), isNull);
      expect(HealthAggregator.latestBloodPressure(const []), isNull);
      expect(HealthAggregator.latestBloodGlucoseMmolPerLiter(const []), isNull);
      expect(HealthAggregator.latestOxygenSaturationPercent(const []), isNull);
    });
  });

  group('filterByRange', () {
    test('drops records outside the period', () {
      final filtered = HealthAggregator.filterByRange(
        [
          steps(
            'inside',
            100,
            dayStart.add(const Duration(hours: 1)),
            dayStart.add(const Duration(hours: 2)),
          ),
          steps(
            'before',
            999,
            dayStart.subtract(const Duration(hours: 3)),
            dayStart.subtract(const Duration(hours: 2)),
          ),
          steps(
            'after',
            999,
            dayEnd.add(const Duration(hours: 1)),
            dayEnd.add(const Duration(hours: 2)),
          ),
        ],
        dayStart,
        dayEnd,
      );

      expect(filtered.map((r) => r.id), ['inside']);
      expect(HealthAggregator.sumSteps(filtered), 100);
    });

    test('keeps records overlapping the period boundary', () {
      final filtered = HealthAggregator.filterByRange(
        [
          steps(
            'overlap',
            50,
            dayStart.subtract(const Duration(minutes: 30)),
            dayStart.add(const Duration(minutes: 30)),
          ),
        ],
        dayStart,
        dayEnd,
      );
      expect(filtered, hasLength(1));
    });
  });
}
