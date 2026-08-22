// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PharmacyProduct _$PharmacyProductFromJson(Map<String, dynamic> json) =>
    _PharmacyProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imgPath: json['imgPath'] as String,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      inStock: json['inStock'] as bool? ?? true,
      stockCount: (json['stockCount'] as num?)?.toInt() ?? 20,
      prescriptionRequired: json['prescriptionRequired'] as bool? ?? true,
      usage: json['usage'] as String? ?? '',
      warnings: json['warnings'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PharmacyProductToJson(_PharmacyProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'category': _$ProductCategoryEnumMap[instance.category]!,
      'description': instance.description,
      'price': instance.price,
      'imgPath': instance.imgPath,
      'discount': instance.discount,
      'inStock': instance.inStock,
      'stockCount': instance.stockCount,
      'prescriptionRequired': instance.prescriptionRequired,
      'usage': instance.usage,
      'warnings': instance.warnings,
      'popularity': instance.popularity,
    };

const _$ProductCategoryEnumMap = {
  ProductCategory.prescriptionMedicines: 'prescriptionMedicines',
  ProductCategory.otcMedicines: 'otcMedicines',
  ProductCategory.vitaminsSupplements: 'vitaminsSupplements',
  ProductCategory.personalCare: 'personalCare',
  ProductCategory.firstAid: 'firstAid',
  ProductCategory.medicalDevices: 'medicalDevices',
  ProductCategory.healthWellness: 'healthWellness',
};
