import 'package:client/feature/pharmacy/data/demo_catalog.dart';
import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pharmaRepositoryProvider = Provider<PharmaRepository>(
  (ref) => PharmaRepository(),
);

/// Demo pharmacy catalogue. There is no external pharmacy API in this project.
class PharmaRepository {
  const PharmaRepository();

  Future<List<PharmacyProduct>> fetchProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<PharmacyProduct>.unmodifiable(DemoCatalog.products);
  }

  Future<List<PharmacyProduct>> searchProducts(String query) async {
    final products = await fetchProducts();
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return products;
    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(needle) ||
              product.brand.toLowerCase().contains(needle) ||
              product.category.label.toLowerCase().contains(needle),
        )
        .toList(growable: false);
  }

  PharmacyProduct? findById(String id) {
    for (final product in DemoCatalog.products) {
      if (product.id == id) return product;
    }
    return null;
  }
}
