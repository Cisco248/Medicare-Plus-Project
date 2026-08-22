// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartRateSummary _$HeartRateSummaryFromJson(Map<String, dynamic> json) =>
    _HeartRateSummary(
      averageBpm: (json['averageBpm'] as num?)?.toDouble(),
      minBpm: (json['minBpm'] as num?)?.toInt(),
      maxBpm: (json['maxBpm'] as num?)?.toInt(),
      restingBpm: (json['restingBpm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HeartRateSummaryToJson(_HeartRateSummary instance) =>
    <String, dynamic>{
      'averageBpm': instance.averageBpm,
      'minBpm': instance.minBpm,
      'maxBpm': instance.maxBpm,
      'restingBpm': instance.restingBpm,
    };

_SleepSummary _$SleepSummaryFromJson(Map<String, dynamic> json) =>
    _SleepSummary(
      totalMinutes: (json['totalMinutes'] as num).toInt(),
      sessionCount: (json['sessionCount'] as num).toInt(),
    );

Map<String, dynamic> _$SleepSummaryToJson(_SleepSummary instance) =>
    <String, dynamic>{
      'totalMinutes': instance.totalMinutes,
      'sessionCount': instance.sessionCount,
    };

_WorkoutSummary _$WorkoutSummaryFromJson(Map<String, dynamic> json) =>
    _WorkoutSummary(
      type: json['type'] as String,
      title: json['title'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$WorkoutSummaryToJson(_WorkoutSummary instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
    };

_BloodPressureSummary _$BloodPressureSummaryFromJson(
  Map<String, dynamic> json,
) => _BloodPressureSummary(
  systolicMmHg: (json['systolicMmHg'] as num).toDouble(),
  diastolicMmHg: (json['diastolicMmHg'] as num).toDouble(),
  measuredAt: json['measuredAt'] == null
      ? null
      : DateTime.parse(json['measuredAt'] as String),
);

Map<String, dynamic> _$BloodPressureSummaryToJson(
  _BloodPressureSummary instance,
) => <String, dynamic>{
  'systolicMmHg': instance.systolicMmHg,
  'diastolicMmHg': instance.diastolicMmHg,
  'measuredAt': instance.measuredAt?.toIso8601String(),
};

_ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    _ActivityModel(
      date: DateTime.parse(json['date'] as String),
      steps: (json['steps'] as num?)?.toInt(),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      activeCalories: (json['activeCalories'] as num?)?.toDouble(),
      totalCalories: (json['totalCalories'] as num?)?.toDouble(),
      heartRate: json['heartRate'] == null
          ? null
          : HeartRateSummary.fromJson(
              json['heartRate'] as Map<String, dynamic>,
            ),
      sleep: json['sleep'] == null
          ? null
          : SleepSummary.fromJson(json['sleep'] as Map<String, dynamic>),
      workouts:
          (json['workouts'] as List<dynamic>?)
              ?.map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkoutSummary>[],
      weightKilograms: (json['weightKilograms'] as num?)?.toDouble(),
      heightMeters: (json['heightMeters'] as num?)?.toDouble(),
      bloodPressure: json['bloodPressure'] == null
          ? null
          : BloodPressureSummary.fromJson(
              json['bloodPressure'] as Map<String, dynamic>,
            ),
      bloodGlucoseMmolPerLiter: (json['bloodGlucoseMmolPerLiter'] as num?)
          ?.toDouble(),
      oxygenSaturationPercent: (json['oxygenSaturationPercent'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$ActivityModelToJson(_ActivityModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'steps': instance.steps,
      'distanceMeters': instance.distanceMeters,
      'activeCalories': instance.activeCalories,
      'totalCalories': instance.totalCalories,
      'heartRate': instance.heartRate,
      'sleep': instance.sleep,
      'workouts': instance.workouts,
      'weightKilograms': instance.weightKilograms,
      'heightMeters': instance.heightMeters,
      'bloodPressure': instance.bloodPressure,
      'bloodGlucoseMmolPerLiter': instance.bloodGlucoseMmolPerLiter,
      'oxygenSaturationPercent': instance.oxygenSaturationPercent,
    };

_HealthDataResult _$HealthDataResultFromJson(Map<String, dynamic> json) =>
    _HealthDataResult(
      status: $enumDecode(_$HealthAccessStatusEnumMap, json['status']),
      activity: json['activity'] == null
          ? null
          : ActivityModel.fromJson(json['activity'] as Map<String, dynamic>),
      deniedMetrics:
          (json['deniedMetrics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$HealthDataResultToJson(_HealthDataResult instance) =>
    <String, dynamic>{
      'status': _$HealthAccessStatusEnumMap[instance.status]!,
      'activity': instance.activity,
      'deniedMetrics': instance.deniedMetrics,
    };

const _$HealthAccessStatusEnumMap = {
  HealthAccessStatus.unavailable: 'unavailable',
  HealthAccessStatus.denied: 'denied',
  HealthAccessStatus.partial: 'partial',
  HealthAccessStatus.granted: 'granted',
};
