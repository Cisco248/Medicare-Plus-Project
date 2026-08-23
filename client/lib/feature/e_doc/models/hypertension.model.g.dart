// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypertension.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HypertensionModel _$HypertensionModelFromJson(Map<String, dynamic> json) =>
    _HypertensionModel(
      age: (json['age'] as num).toInt(),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      hba1c: (json['hba1c'] as num).toDouble(),
      cholesterolMgdl: (json['cholesterol_mgdl'] as num).toDouble(),
      diabetesOrdinal: $enumDecode(
        _$DiabetesOrdinalEnumMap,
        json['diabetes_ordinal'],
      ),
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$HypertensionModelToJson(_HypertensionModel instance) =>
    <String, dynamic>{
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'hba1c': instance.hba1c,
      'cholesterol_mgdl': instance.cholesterolMgdl,
      'diabetes_ordinal': _$DiabetesOrdinalEnumMap[instance.diabetesOrdinal]!,
      'gender': instance.gender,
    };

const _$DiabetesOrdinalEnumMap = {
  DiabetesOrdinal.normal: 'normal',
  DiabetesOrdinal.preDiabetic: 'pre-diabetic',
  DiabetesOrdinal.diabetic: 'diabetic',
};
