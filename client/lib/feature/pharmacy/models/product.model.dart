import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.model.freezed.dart';
part 'product.model.g.dart';

enum ProductCategory {
  prescriptionMedicines('Prescription Medicines'),
  otcMedicines('OTC Medicines'),
  vitaminsSupplements('Vitamins & Supplements'),
  personalCare('Personal Care'),
  firstAid('First Aid'),
  medicalDevices('Medical Devices'),
  healthWellness('Health & Wellness');

  const ProductCategory(this.label);
  final String label;
}

enum ProductSort { priceLow, priceHigh, name, popularity }

@Freezed(
  fromJson: true,
  toJson: true,
  copyWith: true,
  genericArgumentFactories: true,
)
abstract class PharmacyProduct with _$PharmacyProduct {
  const PharmacyProduct._();

  const factory PharmacyProduct({
    required String id,
    required String name,
    required String brand,
    required ProductCategory category,
    required String description,
    required double price,
    required String imgPath,
    @Default(0.0) double discount,
    @Default(true) bool inStock,
    @Default(20) int stockCount,
    @Default(true) bool prescriptionRequired,
    @Default('') String usage,
    @Default('') String warnings,
    @Default(0) int popularity,
  }) = _PharmacyProduct;

  double get discountedPrice =>
      discount <= 0 ? price : price * (1 - discount.clamp(0, 0.8));

  bool get hasDiscount => discount > 0;

  factory PharmacyProduct.fromJson(Map<String, dynamic> json) =>
      _$PharmacyProductFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$PharmacyProductToJson(this as _PharmacyProduct);
}
