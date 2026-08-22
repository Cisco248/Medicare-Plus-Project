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

@Freezed(fromJson: true, toJson: true, toStringOverride: true, copyWith: true)
abstract class HealthDataResult with _$HealthDataResult {
  const factory HealthDataResult({
    required HealthAccessStatus status,
    @Default(null) ActivityModel? activity,
    @Default(<String>[]) List<String> deniedMetrics,
  }) = _HealthDataResult;
}
