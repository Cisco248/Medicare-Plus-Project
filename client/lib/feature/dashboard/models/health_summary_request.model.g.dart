// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_summary_request.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SummaryPeriod _$SummaryPeriodFromJson(Map<String, dynamic> json) =>
    _SummaryPeriod(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      timezoneOffset: json['timezoneOffset'] as String?,
    );

Map<String, dynamic> _$SummaryPeriodToJson(_SummaryPeriod instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'timezoneOffset': instance.timezoneOffset,
    };

_HealthSummaryRequest _$HealthSummaryRequestFromJson(
  Map<String, dynamic> json,
) => _HealthSummaryRequest(
  userId: json['userId'] as String?,
  period: SummaryPeriod.fromJson(json['period'] as Map<String, dynamic>),
  activities: ActivityModel.fromJson(
    json['activities'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$HealthSummaryRequestToJson(
  _HealthSummaryRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'period': instance.period,
  'activities': instance.activities,
};
