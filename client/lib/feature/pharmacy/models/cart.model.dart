import 'package:client/feature/pharmacy/models/product.model.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final PharmacyProduct product;
  final int quantity;

  double get lineTotal => product.discountedPrice * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  Map<String, Object?> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    product: PharmacyProduct.fromJson(json['product'] as Map<String, dynamic>),
    quantity: json['quantity'] as int? ?? 1,
  );
}

class CartState {
  const CartState({this.items = const []});

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get deliveryFee => isEmpty || subtotal >= 3500 ? 0 : 250;
  double get discount => items.fold(
    0,
    (sum, item) =>
        sum + ((item.product.price - item.product.discountedPrice) * item.quantity),
  );
  double get total => subtotal + deliveryFee;

  CartItem? find(String productId) {
    for (final item in items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }

  Map<String, Object?> toJson() => {
    'items': items.map((item) => item.toJson()).toList(),
  };

  factory CartState.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] as List<dynamic>? ?? const [];
    return CartState(
      items: raw
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
