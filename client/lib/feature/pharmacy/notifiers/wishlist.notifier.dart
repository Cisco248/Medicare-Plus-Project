import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/notifiers/pharmacy.notifier.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _store = PharmacyStoreRepository();

class WishlistNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async => await _store.loadWishlist();

  bool contains(String productId) => state.value?.contains(productId) ?? false;

  Future<void> toggle(String productId) async {
    final current = List<String>.from(state.value ?? const []);
    if (current.contains(productId)) {
      current.remove(productId);
    } else {
      current.add(productId);
    }
    state = AsyncData(current);
    await _store.saveWishlist(current);
  }
}

final wishlistProvider = AsyncNotifierProvider<WishlistNotifier, List<String>>(
  WishlistNotifier.new,
);

final wishlistProductsProvider = Provider<List<PharmacyProduct>>((ref) {
  final ids = ref.watch(wishlistProvider).value ?? const [];
  final catalog = ref.watch(pharmacyCatalogProvider).value ?? const [];
  return catalog.where((product) => ids.contains(product.id)).toList();
});
