import 'package:client/feature/pharmacy/models/pharma_query.model.dart';
import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/repositories/pharma.repository.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pharmacy.notifier.g.dart';

final _repository = PharmaRepository();
final _store = PharmacyStoreRepository();

@riverpod
class PharmacyCatalogNotifier extends _$PharmacyCatalogNotifier {
  @override
  Future<List<PharmacyProduct>> build() async =>
      await _repository.fetchProducts();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => await _repository.fetchProducts(),
    );
  }
}

@Riverpod()
class PharmacyQueryNotifier extends _$PharmacyQueryNotifier {
  @override
  PharmacyQuery build() => const PharmacyQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setCategory(ProductCategory? value) =>
      state = state.copyWith(category: value);

  void setSort(ProductSort value) => state = state.copyWith(sort: value);

  void setPriceRange(double? min, double? max) =>
      state = state.copyWith(minPrice: min, maxPrice: max);
}

@riverpod
class RecentProductsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async => await _store.loadRecent();

  Future<void> view(String productId) async {
    final current = List<String>.from(state.value ?? const []);
    current.remove(productId);
    current.insert(0, productId);
    final next = current.take(8).toList();
    state = AsyncData(next);
    await _store.saveRecent(next);
  }
}
