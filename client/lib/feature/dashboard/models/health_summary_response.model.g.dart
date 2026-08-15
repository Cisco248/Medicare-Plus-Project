// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_summary_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthSummaryResponse _$HealthSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _HealthSummaryResponse(
  summary: json['summary'] as String,
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  disclaimer: json['disclaimer'] as String?,
  generatedAt: json['generated_at'] == null
      ? null
      : DateTime.parse(json['generated_at'] as String),
);

Map<String, dynamic> _$HealthSummaryResponseToJson(
  _HealthSummaryResponse instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'recommendations': instance.recommendations,
  'disclaimer': instance.disclaimer,
  'generated_at': instance.generatedAt?.toIso8601String(),
};
