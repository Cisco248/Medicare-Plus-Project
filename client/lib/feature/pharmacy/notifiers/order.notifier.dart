import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/pharmacy/models/cart.model.dart';
import 'package:client/feature/pharmacy/models/order.model.dart';
import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order.notifier.g.dart';

@riverpod
class OrderNotifier extends _$OrderNotifier {
  final _store = PharmacyStoreRepository();

  @override
  Future<List<PharmacyOrder>> build() async => await _store.loadOrders();

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
    await _store.saveOrders(current);
    await _store.saveAddress(address);
    if (paymentStatus == PaymentStatus.successful) {
      await ref.read(cartProvider.notifier).clear();
    }
    return order;
  }
}

@riverpod
class LastAddress extends _$LastAddress {
  final _store = PharmacyStoreRepository();

  @override
  Future<DeliveryAddress?> build() async => await _store.loadAddress();
}
