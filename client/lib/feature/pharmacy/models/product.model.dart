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

class PharmacyProduct {
  const PharmacyProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.imgPath,
    this.discount = 0,
    this.inStock = true,
    this.stockCount = 20,
    this.prescriptionRequired = false,
    this.usage = '',
    this.warnings = '',
    this.popularity = 0,
  });

  final String id;
  final String name;
  final String brand;
  final ProductCategory category;
  final String description;
  final double price;
  final double discount;
  final bool inStock;
  final int stockCount;
  final bool prescriptionRequired;
  final String usage;
  final String warnings;
  final String imgPath;
  final int popularity;

  double get discountedPrice =>
      discount <= 0 ? price : price * (1 - discount.clamp(0, 0.8));

  bool get hasDiscount => discount > 0;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'brand': brand,
    'category': category.name,
    'description': description,
    'price': price,
    'discount': discount,
    'inStock': inStock,
    'stockCount': stockCount,
    'prescriptionRequired': prescriptionRequired,
    'usage': usage,
    'warnings': warnings,
    'imgPath': imgPath,
    'popularity': popularity,
  };

  factory PharmacyProduct.fromJson(Map<String, dynamic> json) {
    return PharmacyProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String? ?? '',
      category: ProductCategory.values.firstWhere(
        (value) => value.name == json['category'],
        orElse: () => ProductCategory.healthWellness,
      ),
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      inStock: json['inStock'] as bool? ?? true,
      stockCount: json['stockCount'] as int? ?? 0,
      prescriptionRequired: json['prescriptionRequired'] as bool? ?? false,
      usage: json['usage'] as String? ?? '',
      warnings: json['warnings'] as String? ?? '',
      imgPath: json['imgPath'] as String? ?? 'assets/images/panadol.png',
      popularity: json['popularity'] as int? ?? 0,
    );
  }
}
