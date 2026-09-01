import 'package:client/feature/dashboard/models/activity.model.dart';
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

  factory WeeklyHealthOverview.fromActivities({
    required String patientId,
    required List<ActivityModel> days,
    String timezone = 'UTC',
  }) {
    return WeeklyHealthOverview(
      patientId: patientId,
      start: days.isEmpty ? DateTime.now() : days.first.date,
      end: days.isEmpty ? DateTime.now() : days.last.date,
      days: days.length,
      timezone: timezone,
      summaries: [for (final day in days) summaryFromActivity(day)],
    );
  }

  WeeklyHealthOverview mergePreferLocal(WeeklyHealthOverview? fallback) {
    if (fallback == null) return this;
    final byDate = {
      for (final day in fallback.summaries) _dateKey(day.date): day,
    };
    return WeeklyHealthOverview(
      patientId: patientId.isEmpty ? fallback.patientId : patientId,
      start: start,
      end: end,
      days: days,
      timezone: timezone,
      summaries: [
        for (final day in summaries)
          _coalesceDay(day, byDate[_dateKey(day.date)]),
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

String _dateKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

ServerDailySummary summaryFromActivity(ActivityModel day) {
  final workoutMinutes = day.workouts.isEmpty
      ? null
      : day.workouts.fold<int>(
          0,
          (sum, workout) => sum + workout.durationMinutes,
        );
  return ServerDailySummary(
    date: day.date,
    steps: day.steps,
    distanceMeters: day.distanceMeters,
    activeCalories: day.activeCalories,
    totalCalories: day.totalCalories,
    averageHeartRate: day.heartRate?.averageBpm,
    minHeartRate: day.heartRate?.minBpm?.toDouble(),
    maxHeartRate: day.heartRate?.maxBpm?.toDouble(),
    restingHeartRate: day.heartRate?.restingBpm,
    sleepMinutes: day.sleep?.totalMinutes,
    activityMinutes: workoutMinutes,
    systolicMmHg: day.bloodPressure?.systolicMmHg,
    diastolicMmHg: day.bloodPressure?.diastolicMmHg,
    bloodGlucoseMmol: day.bloodGlucoseMmolPerLiter,
    oxygenSaturationPercent: day.oxygenSaturationPercent,
    weightKg: day.weightKilograms,
    heightCm: day.heightMeters == null ? null : day.heightMeters! * 100,
  );
}

ServerDailySummary _coalesceDay(
  ServerDailySummary local,
  ServerDailySummary? remote,
) {
  if (remote == null) return local;
  return ServerDailySummary(
    date: local.date,
    steps: local.steps ?? remote.steps,
    distanceMeters: local.distanceMeters ?? remote.distanceMeters,
    activeCalories: local.activeCalories ?? remote.activeCalories,
    totalCalories: local.totalCalories ?? remote.totalCalories,
    averageHeartRate: local.averageHeartRate ?? remote.averageHeartRate,
    minHeartRate: local.minHeartRate ?? remote.minHeartRate,
    maxHeartRate: local.maxHeartRate ?? remote.maxHeartRate,
    restingHeartRate: local.restingHeartRate ?? remote.restingHeartRate,
    sleepMinutes: local.sleepMinutes ?? remote.sleepMinutes,
    activityMinutes: local.activityMinutes ?? remote.activityMinutes,
    systolicMmHg: local.systolicMmHg ?? remote.systolicMmHg,
    diastolicMmHg: local.diastolicMmHg ?? remote.diastolicMmHg,
    bloodGlucoseMmol: local.bloodGlucoseMmol ?? remote.bloodGlucoseMmol,
    oxygenSaturationPercent:
        local.oxygenSaturationPercent ?? remote.oxygenSaturationPercent,
    weightKg: local.weightKg ?? remote.weightKg,
    heightCm: local.heightCm ?? remote.heightCm,
    anomalies: local.anomalies.isNotEmpty ? local.anomalies : remote.anomalies,
    aiSummary: local.aiSummary ?? remote.aiSummary,
    recommendations: local.recommendations.isNotEmpty
        ? local.recommendations
        : remote.recommendations,
    disclaimer: local.disclaimer ?? remote.disclaimer,
  );
}
