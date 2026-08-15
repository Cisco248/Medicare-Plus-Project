import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/pharmacy/models/cart.model.dart';
import 'package:client/feature/pharmacy/models/order.model.dart';
import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class OrderNotifier extends AsyncNotifier<List<PharmacyOrder>> {
  @override
  Future<List<PharmacyOrder>> build() {
    return ref.read(pharmacyStoreProvider).loadOrders();
  }

  Future<PharmacyOrder> placeOrder({
    required CartState cart,
    required DeliveryAddress address,
    required PaymentMethod method,
    required PaymentStatus paymentStatus,
  }) async {
    final user = ref.read(authenticationProvider).value?.data;
    final order = PharmacyOrder(
      orderId: 'ORD-${const Uuid().v4().substring(0, 8).toUpperCase()}',
      userId: user?.email ?? 'local-user',
      items: cart.items,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      discount: cart.discount,
      total: cart.total,
      deliveryAddress: address,
      paymentMethod: method,
      paymentStatus: paymentStatus,
      orderStatus: paymentStatus == PaymentStatus.successful
          ? OrderStatus.confirmed
          : OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    final current = List<PharmacyOrder>.from(state.value ?? const []);
    current.insert(0, order);
    state = AsyncData(current);
    await ref.read(pharmacyStoreProvider).saveOrders(current);
    await ref.read(pharmacyStoreProvider).saveAddress(address);
    if (paymentStatus == PaymentStatus.successful) {
      await ref.read(cartProvider.notifier).clear();
    }
    return order;
  }
}

final orderProvider = AsyncNotifierProvider<OrderNotifier, List<PharmacyOrder>>(
  OrderNotifier.new,
);

final lastAddressProvider = FutureProvider<DeliveryAddress?>((ref) {
  return ref.read(pharmacyStoreProvider).loadAddress();
});
