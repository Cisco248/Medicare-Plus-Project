// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartRateSummary _$HeartRateSummaryFromJson(Map<String, dynamic> json) =>
    _HeartRateSummary(
      averageBpm: (json['average_bpm'] as num?)?.toDouble(),
      minBpm: (json['min_bpm'] as num?)?.toInt(),
      maxBpm: (json['max_bpm'] as num?)?.toInt(),
      restingBpm: (json['resting_bpm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HeartRateSummaryToJson(_HeartRateSummary instance) =>
    <String, dynamic>{
      'average_bpm': instance.averageBpm,
      'min_bpm': instance.minBpm,
      'max_bpm': instance.maxBpm,
      'resting_bpm': instance.restingBpm,
    };

_SleepSummary _$SleepSummaryFromJson(Map<String, dynamic> json) =>
    _SleepSummary(
      totalMinutes: (json['total_minutes'] as num).toInt(),
      sessionCount: (json['session_count'] as num).toInt(),
    );

Map<String, dynamic> _$SleepSummaryToJson(_SleepSummary instance) =>
    <String, dynamic>{
      'total_minutes': instance.totalMinutes,
      'session_count': instance.sessionCount,
    };

_WorkoutSummary _$WorkoutSummaryFromJson(Map<String, dynamic> json) =>
    _WorkoutSummary(
      type: json['type'] as String,
      title: json['title'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$WorkoutSummaryToJson(_WorkoutSummary instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
    };

_BloodPressureSummary _$BloodPressureSummaryFromJson(
  Map<String, dynamic> json,
) => _BloodPressureSummary(
  systolicMmHg: (json['systolic_mm_hg'] as num).toDouble(),
  diastolicMmHg: (json['diastolic_mm_hg'] as num).toDouble(),
  measuredAt: json['measured_at'] == null
      ? null
      : DateTime.parse(json['measured_at'] as String),
);

Map<String, dynamic> _$BloodPressureSummaryToJson(
  _BloodPressureSummary instance,
) => <String, dynamic>{
  'systolic_mm_hg': instance.systolicMmHg,
  'diastolic_mm_hg': instance.diastolicMmHg,
  'measured_at': instance.measuredAt?.toIso8601String(),
};

_ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    _ActivityModel(
      date: DateTime.parse(json['date'] as String),
      steps: (json['steps'] as num?)?.toInt(),
      distanceMeters: (json['distance_meters'] as num?)?.toDouble(),
      activeCalories: (json['active_calories'] as num?)?.toDouble(),
      totalCalories: (json['total_calories'] as num?)?.toDouble(),
      heartRate: json['heart_rate'] == null
          ? null
          : HeartRateSummary.fromJson(
              json['heart_rate'] as Map<String, dynamic>,
            ),
      sleep: json['sleep'] == null
          ? null
          : SleepSummary.fromJson(json['sleep'] as Map<String, dynamic>),
      workouts:
          (json['workouts'] as List<dynamic>?)
              ?.map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkoutSummary>[],
      weightKilograms: (json['weight_kilograms'] as num?)?.toDouble(),
      heightMeters: (json['height_meters'] as num?)?.toDouble(),
      bloodPressure: json['blood_pressure'] == null
          ? null
          : BloodPressureSummary.fromJson(
              json['blood_pressure'] as Map<String, dynamic>,
            ),
      bloodGlucoseMmolPerLiter: (json['blood_glucose_mmol_per_liter'] as num?)
          ?.toDouble(),
      oxygenSaturationPercent: (json['oxygen_saturation_percent'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$ActivityModelToJson(_ActivityModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'steps': instance.steps,
      'distance_meters': instance.distanceMeters,
      'active_calories': instance.activeCalories,
      'total_calories': instance.totalCalories,
      'heart_rate': instance.heartRate?.toJson(),
      'sleep': instance.sleep?.toJson(),
      'workouts': instance.workouts.map((e) => e.toJson()).toList(),
      'weight_kilograms': instance.weightKilograms,
      'height_meters': instance.heightMeters,
      'blood_pressure': instance.bloodPressure?.toJson(),
      'blood_glucose_mmol_per_liter': instance.bloodGlucoseMmolPerLiter,
      'oxygen_saturation_percent': instance.oxygenSaturationPercent,
    };
