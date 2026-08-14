import 'dart:convert';

import 'package:client/core/utils/pref_storage.utils.dart';
import 'package:client/feature/pharmacy/data/demo_catalog.dart';
import 'package:client/feature/pharmacy/models/cart.model.dart';
import 'package:client/feature/pharmacy/models/order.model.dart';
import 'package:client/feature/pharmacy/models/prescription.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _cartKey = 'pharmacy_cart';
const _wishlistKey = 'pharmacy_wishlist';
const _ordersKey = 'pharmacy_orders';
const _addressKey = 'pharmacy_address';
const _recentKey = 'pharmacy_recent';
const _rxKey = 'pharmacy_prescriptions';

final pharmacyStoreProvider = Provider<PharmacyStoreRepository>(
  (ref) => PharmacyStoreRepository(),
);

/// Persists cart, wishlist, orders and related demo state with SharedPreferences.
class PharmacyStoreRepository {
  PharmacyStoreRepository({PrefStorageUtils? storage})
    : _storage = storage ?? PrefStorageUtils();

  final PrefStorageUtils _storage;

  Future<CartState> loadCart() async {
    final raw = await _storage.getString(_cartKey);
    if (raw == null || raw.isEmpty) return const CartState();
    return CartState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveCart(CartState cart) async {
    await _storage.setString(_cartKey, jsonEncode(cart.toJson()));
  }

  Future<List<String>> loadWishlist() async {
    final raw = await _storage.getString(_wishlistKey);
    if (raw == null || raw.isEmpty) return const [];
    return (jsonDecode(raw) as List<dynamic>).cast<String>();
  }

  Future<void> saveWishlist(List<String> ids) async {
    await _storage.setString(_wishlistKey, jsonEncode(ids));
  }

  Future<List<PharmacyOrder>> loadOrders() async {
    final raw = await _storage.getString(_ordersKey);
    if (raw == null || raw.isEmpty) {
      final seeded = _demoOrders();
      await saveOrders(seeded);
      return seeded;
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => PharmacyOrder.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveOrders(List<PharmacyOrder> orders) async {
    await _storage.setString(
      _ordersKey,
      jsonEncode(orders.map((order) => order.toJson()).toList()),
    );
  }

  Future<DeliveryAddress?> loadAddress() async {
    final raw = await _storage.getString(_addressKey);
    if (raw == null || raw.isEmpty) return null;
    return DeliveryAddress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveAddress(DeliveryAddress address) async {
    await _storage.setString(_addressKey, jsonEncode(address.toJson()));
  }

  Future<List<String>> loadRecent() async {
    final raw = await _storage.getString(_recentKey);
    if (raw == null || raw.isEmpty) return const [];
    return (jsonDecode(raw) as List<dynamic>).cast<String>();
  }

  Future<void> saveRecent(List<String> ids) async {
    await _storage.setString(_recentKey, jsonEncode(ids));
  }

  Future<Map<String, PrescriptionRecord>> loadPrescriptions() async {
    final raw = await _storage.getString(_rxKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(
        key,
        PrescriptionRecord.fromJson(value as Map<String, dynamic>),
      ),
    );
  }

  Future<void> savePrescriptions(Map<String, PrescriptionRecord> records) async {
    await _storage.setString(
      _rxKey,
      jsonEncode(records.map((key, value) => MapEntry(key, value.toJson()))),
    );
  }

  List<PharmacyOrder> _demoOrders() => [
    PharmacyOrder(
      orderId: 'ORD-DEMO-1001',
      userId: 'demo',
      items: [
        CartItem(product: DemoCatalog.products.first, quantity: 2),
      ],
      subtotal: 2100,
      deliveryFee: 250,
      discount: 150,
      total: 2350,
      deliveryAddress: const DeliveryAddress(
        fullName: 'Demo User',
        phone: '0770000000',
        line1: '12 Demo Street',
        city: 'Colombo',
      ),
      paymentMethod: PaymentMethod.cashOnDelivery,
      paymentStatus: PaymentStatus.successful,
      orderStatus: OrderStatus.delivered,
      createdAt: DateTime(2026, 7, 18),
    ),
  ];
}
