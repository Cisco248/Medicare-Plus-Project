import 'package:client/feature/pharmacy/models/cart.model.dart';
import 'package:client/feature/pharmacy/models/prescription.model.dart';
import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/notifiers/prescription.notifier.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends AsyncNotifier<CartState> {
  @override
  Future<CartState> build() {
    return ref.read(pharmacyStoreProvider).loadCart();
  }

  Future<void> _persist(CartState cart) async {
    state = AsyncData(cart);
    await ref.read(pharmacyStoreProvider).saveCart(cart);
  }

  Future<String?> add(PharmacyProduct product, {int quantity = 1}) async {
    if (!product.inStock) return 'This item is currently out of stock.';
    if (product.prescriptionRequired) {
      final record = ref.read(prescriptionProvider)[product.id];
      if (record == null || record.status != PrescriptionStatus.approved) {
        return 'A verified prescription is required before this item can be added.';
      }
    }
    final current = state.value ?? const CartState();
    final existing = current.find(product.id);
    final nextItems = [...current.items];
    if (existing == null) {
      nextItems.add(CartItem(product: product, quantity: quantity));
    } else {
      final index = nextItems.indexWhere((item) => item.product.id == product.id);
      nextItems[index] = existing.copyWith(quantity: existing.quantity + quantity);
    }
    await _persist(CartState(items: nextItems));
    return null;
  }

  Future<void> setQuantity(String productId, int quantity) async {
    final current = state.value ?? const CartState();
    if (quantity <= 0) {
      await remove(productId);
      return;
    }
    final nextItems = current.items
        .map(
          (item) => item.product.id == productId
              ? item.copyWith(quantity: quantity)
              : item,
        )
        .toList();
    await _persist(CartState(items: nextItems));
  }

  Future<void> remove(String productId) async {
    final current = state.value ?? const CartState();
    await _persist(
      CartState(
        items: current.items
            .where((item) => item.product.id != productId)
            .toList(),
      ),
    );
  }

  Future<void> clear() async {
    await _persist(const CartState());
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
