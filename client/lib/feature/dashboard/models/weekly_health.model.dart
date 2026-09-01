import 'package:client/feature/dashboard/models/server_health.model.dart';

class WeeklyMetricPoint {
  const WeeklyMetricPoint({required this.date, this.value});

  final DateTime date;
  final double? value;

  bool get hasData => value != null;
}

class WeeklyHealthOverview {
  const WeeklyHealthOverview({
    required this.patientId,
    required this.start,
    required this.end,
    required this.days,
    required this.timezone,
    required this.summaries,
  });

  final String patientId;
  final DateTime start;
  final DateTime end;
  final int days;
  final String timezone;
  final List<ServerDailySummary> summaries;

  factory WeeklyHealthOverview.fromJson(Map<String, dynamic> json) {
    return WeeklyHealthOverview(
      patientId: json['patient_id'] as String? ?? '',
      start: parseCalendarDate(json['start'] as String? ?? ''),
      end: parseCalendarDate(json['end'] as String? ?? ''),
      days: (json['days'] as num?)?.toInt() ?? 7,
      timezone: json['timezone'] as String? ?? 'UTC',
      summaries: [
        for (final item in json['summaries'] as List? ?? const [])
          ServerDailySummary.fromJson(Map<String, dynamic>.from(item as Map)),
      ],
    );
  }

  List<WeeklyMetricPoint> stepsSeries() {
    return [
      for (final day in summaries)
        WeeklyMetricPoint(date: day.date, value: day.steps?.toDouble()),
    ];
  }

  List<WeeklyMetricPoint> caloriesSeries() {
    return [
      for (final day in summaries)
        WeeklyMetricPoint(
          date: day.date,
          value: day.activeCalories ?? day.totalCalories,
        ),
    ];
  }

  List<WeeklyMetricPoint> sleepHoursSeries() {
    return [
      for (final day in summaries)
        WeeklyMetricPoint(
          date: day.date,
          value: day.sleepMinutes == null ? null : day.sleepMinutes! / 60.0,
        ),
    ];
  }

  /// Uses recorded activity minutes when present; otherwise active calories.
  List<WeeklyMetricPoint> activitySeries() {
    final hasMinutes = summaries.any((day) => day.activityMinutes != null);
    if (hasMinutes) {
      return [
        for (final day in summaries)
          WeeklyMetricPoint(
            date: day.date,
            value: day.activityMinutes?.toDouble(),
          ),
      ];
    }
    return [
      for (final day in summaries)
        WeeklyMetricPoint(date: day.date, value: day.activeCalories),
    ];
  }

  bool get activityUsesMinutes =>
      summaries.any((day) => day.activityMinutes != null);

  WeeklySeriesStats? statsFor(List<WeeklyMetricPoint> series) {
    final present = series.where((point) => point.hasData).toList();
    if (present.isEmpty) return null;
    final values = [for (final point in present) point.value!];
    final total = values.fold<double>(0, (sum, value) => sum + value);
    WeeklyMetricPoint highest = present.first;
    WeeklyMetricPoint lowest = present.first;
    for (final point in present) {
      if (point.value! >= highest.value!) highest = point;
      if (point.value! <= lowest.value!) lowest = point;
    }
    return WeeklySeriesStats(
      total: total,
      average: total / present.length,
      highest: highest,
      lowest: lowest,
      daysWithData: present.length,
    );
  }
}

class WeeklySeriesStats {
  const WeeklySeriesStats({
    required this.total,
    required this.average,
    required this.highest,
    required this.lowest,
    required this.daysWithData,
  });

  final double total;
  final double average;
  final WeeklyMetricPoint highest;
  final WeeklyMetricPoint lowest;
  final int daysWithData;
}

String weekdayLabel(DateTime date) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return labels[date.weekday - 1];
}
