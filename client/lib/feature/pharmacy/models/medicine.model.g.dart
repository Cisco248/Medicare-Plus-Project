// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) =>
    _MedicineModel(
      medicineName: json['medicineName'] as String,
      category: $enumDecode(_$MedicineCategoryEnumMap, json['category']),
      dosage: (json['dosage'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      imgPath: json['imgPath'] as String,
    );

Map<String, dynamic> _$MedicineModelToJson(_MedicineModel instance) =>
    <String, dynamic>{
      'medicineName': instance.medicineName,
      'category': _$MedicineCategoryEnumMap[instance.category]!,
      'dosage': instance.dosage,
      'price': instance.price,
      'imgPath': instance.imgPath,
    };

const _$MedicineCategoryEnumMap = {
  MedicineCategory.tablet: 'tablet',
  MedicineCategory.capsule: 'capsule',
  MedicineCategory.syrup: 'syrup',
  MedicineCategory.injection: 'injection',
};
