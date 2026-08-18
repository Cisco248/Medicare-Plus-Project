// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diabetes.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiabetesModel _$DiabetesModelFromJson(Map<String, dynamic> json) =>
    _DiabetesModel(
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      pulseRate: (json['pulseRate'] as num).toDouble(),
      bpReading: json['bpReading'] as String,
      glucose: (json['glucose'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      familyDiabetes: json['familyDiabetes'] as String,
      hypertensive: json['hypertensive'] as String,
    );

Map<String, dynamic> _$DiabetesModelToJson(_DiabetesModel instance) =>
    <String, dynamic>{
      'age': instance.age,
      'gender': instance.gender,
      'pulseRate': instance.pulseRate,
      'bpReading': instance.bpReading,
      'glucose': instance.glucose,
      'bmi': instance.bmi,
      'familyDiabetes': instance.familyDiabetes,
      'hypertensive': instance.hypertensive,
    };

_DiabetesResultModel _$DiabetesResultModelFromJson(Map<String, dynamic> json) =>
    _DiabetesResultModel(
      prediction: (json['prediction'] as num).toInt(),
      riskProbability: (json['riskProbability'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$DiabetesResultModelToJson(
  _DiabetesResultModel instance,
) => <String, dynamic>{
  'prediction': instance.prediction,
  'riskProbability': instance.riskProbability,
  'status': instance.status,
};
