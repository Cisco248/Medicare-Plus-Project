// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc.state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocState _$DocStateFromJson(Map<String, dynamic> json) => _DocState(
  phase: $enumDecodeNullable(_$DocPhaseEnumMap, json['phase']) ?? DocPhase.idle,
  model: $enumDecodeNullable(_$DocModelEnumMap, json['model']) ?? null,
  prediction: json['prediction'] as String? ?? null,
  explanation: json['explanation'] as String? ?? null,
  errorMessage: json['errorMessage'] as String? ?? null,
);

Map<String, dynamic> _$DocStateToJson(_DocState instance) => <String, dynamic>{
  'phase': _$DocPhaseEnumMap[instance.phase]!,
  'model': _$DocModelEnumMap[instance.model],
  'prediction': instance.prediction,
  'explanation': instance.explanation,
  'errorMessage': instance.errorMessage,
};

const _$DocPhaseEnumMap = {
  DocPhase.idle: 'idle',
  DocPhase.loading: 'loading',
  DocPhase.success: 'success',
  DocPhase.empty: 'empty',
  DocPhase.error: 'error',
};

const _$DocModelEnumMap = {
  DocModel.diabetes: 'diabetes',
  DocModel.hypertension: 'hypertension',
  DocModel.bloodPressure: 'bloodPressure',
};
