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
}
