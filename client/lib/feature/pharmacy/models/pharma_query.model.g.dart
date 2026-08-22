// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharma_query.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PharmacyQuery _$PharmacyQueryFromJson(Map<String, dynamic> json) =>
    _PharmacyQuery(
      search: json['search'] as String? ?? '',
      category:
          $enumDecodeNullable(_$ProductCategoryEnumMap, json['category']) ??
          ProductCategory.firstAid,
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 0.0,
      sort:
          $enumDecodeNullable(_$ProductSortEnumMap, json['sort']) ??
          ProductSort.name,
    );

Map<String, dynamic> _$PharmacyQueryToJson(_PharmacyQuery instance) =>
    <String, dynamic>{
      'search': instance.search,
      'category': _$ProductCategoryEnumMap[instance.category],
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'sort': _$ProductSortEnumMap[instance.sort]!,
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

const _$ProductSortEnumMap = {
  ProductSort.priceLow: 'priceLow',
  ProductSort.priceHigh: 'priceHigh',
  ProductSort.name: 'name',
  ProductSort.popularity: 'popularity',
};
