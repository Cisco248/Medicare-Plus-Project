import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/repositories/pharma.repository.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PharmacyQuery {
  const PharmacyQuery({
    this.search = '',
    this.category,
    this.minPrice,
    this.maxPrice,
    this.sort = ProductSort.popularity,
  });

  final String search;
  final ProductCategory? category;
  final double? minPrice;
  final double? maxPrice;
  final ProductSort sort;

  PharmacyQuery copyWith({
    String? search,
    ProductCategory? category,
    double? minPrice,
    double? maxPrice,
    ProductSort? sort,
    bool clearCategory = false,
    bool clearPrices = false,
  }) {
    return PharmacyQuery(
      search: search ?? this.search,
      category: clearCategory ? null : category ?? this.category,
      minPrice: clearPrices ? null : minPrice ?? this.minPrice,
      maxPrice: clearPrices ? null : maxPrice ?? this.maxPrice,
      sort: sort ?? this.sort,
    );
  }

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

class PharmacyCatalogNotifier extends AsyncNotifier<List<PharmacyProduct>> {
  @override
  Future<List<PharmacyProduct>> build() {
    return ref.read(pharmaRepositoryProvider).fetchProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(pharmaRepositoryProvider).fetchProducts(),
    );
  }
}

class PharmacyQueryNotifier extends Notifier<PharmacyQuery> {
  @override
  PharmacyQuery build() => const PharmacyQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setCategory(ProductCategory? value) =>
      state = state.copyWith(category: value, clearCategory: value == null);

  void setSort(ProductSort value) => state = state.copyWith(sort: value);

  void setPriceRange(double? min, double? max) =>
      state = state.copyWith(minPrice: min, maxPrice: max, clearPrices: min == null && max == null);
}

class RecentProductsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() {
    return ref.read(pharmacyStoreProvider).loadRecent();
  }

  Future<void> view(String productId) async {
    final current = List<String>.from(state.value ?? const []);
    current.remove(productId);
    current.insert(0, productId);
    final next = current.take(8).toList();
    state = AsyncData(next);
    await ref.read(pharmacyStoreProvider).saveRecent(next);
  }
}

final pharmacyCatalogProvider =
    AsyncNotifierProvider<PharmacyCatalogNotifier, List<PharmacyProduct>>(
      PharmacyCatalogNotifier.new,
    );

final pharmacyQueryProvider =
    NotifierProvider<PharmacyQueryNotifier, PharmacyQuery>(
      PharmacyQueryNotifier.new,
    );

final recentProductsProvider =
    AsyncNotifierProvider<RecentProductsNotifier, List<String>>(
      RecentProductsNotifier.new,
    );

/// Kept so any leftover `pharmacyProvider` imports continue to resolve.
final pharmacyProvider = pharmacyCatalogProvider;
