import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/weekly_health.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('WeeklyHealthOverview keeps missing days as null, not zero', () {
    final overview = WeeklyHealthOverview.fromJson({
      'patient_id': 'user-1',
      'start': '2026-08-25',
      'end': '2026-08-31',
      'days': 7,
      'timezone': 'Asia/Colombo',
      'summaries': [
        {'date': '2026-08-25', 'steps': 5000, 'active_calories': 220.0},
        {'date': '2026-08-26'},
        {
          'date': '2026-08-27',
          'steps': 0,
          'active_calories': 0,
          'sleep_minutes': 0,
        },
        {'date': '2026-08-28', 'steps': 7200, 'sleep_minutes': 420},
        {'date': '2026-08-29'},
        {'date': '2026-08-30', 'steps': 8000, 'activity_minutes': 45},
        {'date': '2026-08-31', 'steps': 4500, 'total_calories': 1900.0},
      ],
    });

    expect(overview.summaries, hasLength(7));
    expect(overview.summaries[0].date, DateTime(2026, 8, 25));

    final steps = overview.stepsSeries();
    expect(steps[0].value, 5000);
    expect(steps[1].hasData, isFalse);
    expect(steps[1].value, isNull);
    expect(steps[2].hasData, isTrue);
    expect(steps[2].value, 0);

    final calories = overview.caloriesSeries();
    expect(calories[0].value, 220);
    expect(calories[1].hasData, isFalse);
    expect(calories[6].value, 1900);

    final sleep = overview.sleepHoursSeries();
    expect(sleep[2].value, 0);
    expect(sleep[3].value, 7);
    expect(sleep[4].hasData, isFalse);

    expect(overview.activityUsesMinutes, isTrue);
    final activity = overview.activitySeries();
    expect(activity[5].value, 45);
    expect(activity[0].hasData, isFalse);

    final stats = overview.statsFor(steps);
    expect(stats, isNotNull);
    expect(stats!.daysWithData, 5);
    expect(stats.total, 5000 + 0 + 7200 + 8000 + 4500);
    expect(stats.average, stats.total / 5);
  });

  test('weekday labels follow local calendar dates', () {
    expect(weekdayLabel(DateTime(2026, 8, 31)), 'Mon');
    expect(weekdayLabel(DateTime(2026, 8, 25)), 'Tue');
  });

  test('fromActivities maps Health Connect days without inventing zeros', () {
    final overview = WeeklyHealthOverview.fromActivities(
      patientId: 'user-1',
      timezone: 'Asia/Colombo',
      days: [
        ActivityModel(date: DateTime(2026, 8, 25), steps: 4100),
        ActivityModel(date: DateTime(2026, 8, 26)),
        ActivityModel(
          date: DateTime(2026, 8, 27),
          activeCalories: 320,
          sleep: SleepSummary(totalMinutes: 390, sessionCount: 1),
          workouts: [
            WorkoutSummary(
              type: 'WALKING',
              startTime: DateTime.utc(2026, 8, 27, 6),
              endTime: DateTime.utc(2026, 8, 27, 6, 40),
              durationMinutes: 40,
            ),
          ],
        ),
      ],
    );

    expect(overview.days, 3);
    expect(overview.stepsSeries()[0].value, 4100);
    expect(overview.stepsSeries()[1].hasData, isFalse);
    expect(overview.caloriesSeries()[2].value, 320);
    expect(overview.sleepHoursSeries()[2].value, 6.5);
    expect(overview.activityUsesMinutes, isTrue);
    expect(overview.activitySeries()[2].value, 40);
    expect(overview.activitySeries()[0].hasData, isFalse);
  });

  test('mergePreferLocal keeps Health Connect values and fills gaps', () {
    final local = WeeklyHealthOverview.fromActivities(
      patientId: 'user-1',
      days: [
        ActivityModel(date: DateTime(2026, 8, 30), steps: 9000),
        ActivityModel(date: DateTime(2026, 8, 31)),
      ],
    );
    final remote = WeeklyHealthOverview.fromJson({
      'patient_id': 'user-1',
      'start': '2026-08-30',
      'end': '2026-08-31',
      'days': 2,
      'summaries': [
        {'date': '2026-08-30', 'steps': 100, 'active_calories': 210.0},
        {'date': '2026-08-31', 'steps': 5500, 'sleep_minutes': 420},
      ],
    });

    final merged = local.mergePreferLocal(remote);
    expect(merged.stepsSeries()[0].value, 9000);
    expect(merged.caloriesSeries()[0].value, 210);
    expect(merged.stepsSeries()[1].value, 5500);
    expect(merged.sleepHoursSeries()[1].value, 7);
  });
}
