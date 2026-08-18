// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diabetes.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiabetesModel _$DiabetesModelFromJson(Map<String, dynamic> json) =>
    _DiabetesModel(
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      pulseRate: (json['pulse_rate'] as num).toDouble(),
      bpReading: json['bp_reading'] as String,
      glucose: (json['glucose'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      familyDiabetes: json['family_diabetes'] as String,
      hypertensive: json['hypertensive'] as String,
    );

Map<String, dynamic> _$DiabetesModelToJson(_DiabetesModel instance) =>
    <String, dynamic>{
      'age': instance.age,
      'gender': instance.gender,
      'pulse_rate': instance.pulseRate,
      'bp_reading': instance.bpReading,
      'glucose': instance.glucose,
      'bmi': instance.bmi,
      'family_diabetes': instance.familyDiabetes,
      'hypertensive': instance.hypertensive,
    };
