import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.model.freezed.dart';
part 'cart.model.g.dart';

@Freezed(toStringOverride: true, copyWith: true, fromJson: true, toJson: true)
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required PharmacyProduct product,
    @Default(0) int quantity,
  }) = _CartItem;

  double get lineTotal => product.discountedPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CartItemToJson(this as _CartItem);
}

@Freezed(toStringOverride: true, copyWith: true, fromJson: true, toJson: true)
abstract class CartState with _$CartState {
  const CartState._();
  const factory CartState({@Default([]) List<CartItem> items}) = _CartState;

  bool get isEmpty => items.isEmpty;
  double get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get deliveryFee => isEmpty || subtotal >= 3500 ? 0 : 250;
  double get discount => items.fold(
    0,
    (sum, item) =>
        sum +
        ((item.product.price - item.product.discountedPrice) * item.quantity),
  );
  double get total => subtotal + deliveryFee;

  CartItem? find(String productId) {
    for (final item in items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }

  factory CartState.fromJson(Map<String, dynamic> json) =>
      _$CartStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CartStateToJson(this as _CartState);
}
