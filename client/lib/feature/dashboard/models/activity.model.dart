import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.model.freezed.dart';
part 'activity.model.g.dart';

@freezed
abstract class HeartRateSummary with _$HeartRateSummary {
  const factory HeartRateSummary({
    double? averageBpm,
    int? minBpm,
    int? maxBpm,
    double? restingBpm,
  }) = _HeartRateSummary;

  factory HeartRateSummary.fromJson(Map<String, Object?> json) =>
      _$HeartRateSummaryFromJson(json);
}

@freezed
abstract class SleepSummary with _$SleepSummary {
  const factory SleepSummary({
    required int totalMinutes,
    required int sessionCount,
  }) = _SleepSummary;

  factory SleepSummary.fromJson(Map<String, Object?> json) =>
      _$SleepSummaryFromJson(json);
}

@freezed
abstract class WorkoutSummary with _$WorkoutSummary {
  const factory WorkoutSummary({
    required String type,
    String? title,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
  }) = _WorkoutSummary;

  factory WorkoutSummary.fromJson(Map<String, Object?> json) =>
      _$WorkoutSummaryFromJson(json);
}

@freezed
abstract class BloodPressureSummary with _$BloodPressureSummary {
  const factory BloodPressureSummary({
    required double systolicMmHg,
    required double diastolicMmHg,
    DateTime? measuredAt,
  }) = _BloodPressureSummary;

  factory BloodPressureSummary.fromJson(Map<String, Object?> json) =>
      _$BloodPressureSummaryFromJson(json);
}

@freezed
abstract class ActivityModel with _$ActivityModel {
  const ActivityModel._();

  const factory ActivityModel({
    required DateTime date,
    int? steps,
    double? distanceMeters,
    double? activeCalories,
    double? totalCalories,
    HeartRateSummary? heartRate,
    SleepSummary? sleep,
    @Default(<WorkoutSummary>[]) List<WorkoutSummary> workouts,
    double? weightKilograms,
    double? heightMeters,
    BloodPressureSummary? bloodPressure,
    double? bloodGlucoseMmolPerLiter,
    double? oxygenSaturationPercent,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, Object?> json) =>
      _$ActivityModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ActivityModelToJson(this as _ActivityModel);

  /// Snake_case payload expected by ``POST /api/knowledge``.
  Map<String, dynamic> toKnowledgeJson() {
    return {
      'date': date.toUtc().toIso8601String(),
      if (steps != null) 'steps': steps,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (activeCalories != null) 'active_calories': activeCalories,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (heartRate != null)
        'heart_rate': {
          if (heartRate!.averageBpm != null)
            'average_bpm': heartRate!.averageBpm,
          if (heartRate!.minBpm != null) 'min_bpm': heartRate!.minBpm,
          if (heartRate!.maxBpm != null) 'max_bpm': heartRate!.maxBpm,
          if (heartRate!.restingBpm != null)
            'resting_bpm': heartRate!.restingBpm,
        },
      if (sleep != null)
        'sleep': {
          'total_minutes': sleep!.totalMinutes,
          'session_count': sleep!.sessionCount,
        },
      if (workouts.isNotEmpty)
        'workouts': [
          for (final workout in workouts)
            {
              'type': workout.type,
              if (workout.title != null) 'title': workout.title,
              'start_time': workout.startTime.toUtc().toIso8601String(),
              'end_time': workout.endTime.toUtc().toIso8601String(),
              'duration_minutes': workout.durationMinutes,
            },
        ],
      if (weightKilograms != null) 'weight_kilograms': weightKilograms,
      if (heightMeters != null) 'height_meters': heightMeters,
      if (bloodPressure != null)
        'blood_pressure': {
          'systolic_mm_hg': bloodPressure!.systolicMmHg,
          'diastolic_mm_hg': bloodPressure!.diastolicMmHg,
          if (bloodPressure!.measuredAt != null)
            'measured_at': bloodPressure!.measuredAt!.toUtc().toIso8601String(),
        },
      if (bloodGlucoseMmolPerLiter != null)
        'blood_glucose_mmol_per_liter': bloodGlucoseMmolPerLiter,
      if (oxygenSaturationPercent != null)
        'oxygen_saturation_percent': oxygenSaturationPercent,
    };
  }

  bool get hasAnyData =>
      steps != null ||
      distanceMeters != null ||
      activeCalories != null ||
      totalCalories != null ||
      heartRate != null ||
      sleep != null ||
      workouts.isNotEmpty ||
      weightKilograms != null ||
      heightMeters != null ||
      bloodPressure != null ||
      bloodGlucoseMmolPerLiter != null ||
      oxygenSaturationPercent != null;
}

enum HealthAccessStatus { unavailable, denied, partial, granted }

class WeeklyActivityResult {
  const WeeklyActivityResult({
    required this.status,
    required this.days,
    this.deniedMetrics = const [],
  });

  final HealthAccessStatus status;
  final List<ActivityModel> days;
  final List<String> deniedMetrics;

  bool get hasAnyData => days.any((day) => day.hasAnyData);
}

@Freezed(fromJson: true, toJson: true, toStringOverride: true, copyWith: true)
abstract class HealthDataResult with _$HealthDataResult {
  const factory HealthDataResult({
    required HealthAccessStatus status,
    @Default(null) ActivityModel? activity,
    @Default(<String>[]) List<String> deniedMetrics,
  }) = _HealthDataResult;
}
