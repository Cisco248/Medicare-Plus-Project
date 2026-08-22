import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharma_query.model.freezed.dart';
part 'pharma_query.model.g.dart';

@Freezed(
  toJson: true,
  fromJson: true,
  toStringOverride: true,
  genericArgumentFactories: true,
  copyWith: true,
)
abstract class PharmacyQuery with _$PharmacyQuery {
  const PharmacyQuery._();
  const factory PharmacyQuery({
    @Default('') String search,
    @Default(ProductCategory.firstAid) ProductCategory? category,
    @Default(0.0) double? minPrice,
    @Default(0.0) double? maxPrice,
    @Default(ProductSort.name) ProductSort sort,
  }) = _PharmacyQuery;

  List<PharmacyProduct> apply(List<PharmacyProduct> products) {
    final needle = search.trim().toLowerCase();
    final filtered = products.where((product) {
      final matchesSearch =
          needle.isEmpty ||
          product.name.toLowerCase().contains(needle) ||
          product.brand.toLowerCase().contains(needle) ||
          product.category.label.toLowerCase().contains(needle);
      final matchesCategory = category == null || product.category == category;
      final price = product.discountedPrice;
      final matchesMin = minPrice == null || price >= minPrice!;
      final matchesMax = maxPrice == null || price <= maxPrice!;
      return matchesSearch && matchesCategory && matchesMin && matchesMax;
    }).toList();

    filtered.sort((a, b) {
      switch (sort) {
        case ProductSort.priceLow:
          return a.discountedPrice.compareTo(b.discountedPrice);
        case ProductSort.priceHigh:
          return b.discountedPrice.compareTo(a.discountedPrice);
        case ProductSort.name:
          return a.name.compareTo(b.name);
        case ProductSort.popularity:
          return b.popularity.compareTo(a.popularity);
      }
    });
    return filtered;
  }
}
