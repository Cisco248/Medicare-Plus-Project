// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    _ActivityModel(
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      walking: (json['walking'] as num?)?.toInt() ?? 0,
      running: (json['running'] as num?)?.toInt() ?? 0,
      climbing: (json['climbing'] as num?)?.toInt() ?? 0,
      sleeping: (json['sleeping'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ActivityModelToJson(_ActivityModel instance) =>
    <String, dynamic>{
      'steps': instance.steps,
      'walking': instance.walking,
      'running': instance.running,
      'climbing': instance.climbing,
      'sleeping': instance.sleeping,
    };
