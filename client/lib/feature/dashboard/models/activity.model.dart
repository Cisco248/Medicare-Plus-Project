// @JsonSerializable on freezed factory constructors is the documented way to
// configure json_serializable for freezed classes.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.model.freezed.dart';
part 'activity.model.g.dart';

/// Aggregated heart-rate statistics for a period.
///
/// `null` fields mean the metric could not be measured, never zero.
@freezed
abstract class HeartRateSummary with _$HeartRateSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HeartRateSummary({
    double? averageBpm,
    int? minBpm,
    int? maxBpm,
    double? restingBpm,
  }) = _HeartRateSummary;

  factory HeartRateSummary.fromJson(Map<String, Object?> json) =>
      _$HeartRateSummaryFromJson(json);
}

/// Aggregated sleep information for a period.
@freezed
abstract class SleepSummary with _$SleepSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SleepSummary({
    required int totalMinutes,
    required int sessionCount,
  }) = _SleepSummary;

  factory SleepSummary.fromJson(Map<String, Object?> json) =>
      _$SleepSummaryFromJson(json);
}

/// A single normalized workout/exercise session.
@freezed
abstract class WorkoutSummary with _$WorkoutSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
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

/// Latest blood-pressure measurement within a period.
@freezed
abstract class BloodPressureSummary with _$BloodPressureSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BloodPressureSummary({
    required double systolicMmHg,
    required double diastolicMmHg,
    DateTime? measuredAt,
  }) = _BloodPressureSummary;

  factory BloodPressureSummary.fromJson(Map<String, Object?> json) =>
      _$BloodPressureSummaryFromJson(json);
}

/// Normalized application-level health/activity data for a period.
///
/// This is the aggregation of raw Health Connect records, not a copy of the
/// SDK objects. Every metric is nullable: `null` means "data unavailable"
/// (missing permission or no records), which must never be interpreted as 0.
@freezed
abstract class ActivityModel with _$ActivityModel {
  const ActivityModel._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
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

  /// Whether at least one health metric was collected for the period.
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
