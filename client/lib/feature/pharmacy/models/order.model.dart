import 'package:client/feature/pharmacy/models/cart.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.model.freezed.dart';
part 'order.model.g.dart';

enum OrderStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  preparing('Preparing'),
  outForDelivery('Out for Delivery'),
  delivered('Delivered'),
  cancelled('Cancelled');

  const OrderStatus(this.label);
  final String label;
}

enum PaymentStatus {
  pending('Pending'),
  successful('Successful'),
  failed('Failed');

  const PaymentStatus(this.label);
  final String label;
}

enum PaymentMethod {
  cashOnDelivery('Cash on Delivery'),
  demoCard('Demo Card Payment');

  const PaymentMethod(this.label);
  final String label;
}

@Freezed(toStringOverride: true, copyWith: true)
abstract class DeliveryAddress with _$DeliveryAddress {
  const DeliveryAddress._();

  const factory DeliveryAddress({
    required String fullName,
    required String phone,
    required String line1,
    @Default('') String line2,
    required String city,
  }) = _DeliveryAddress;

  String get formatted {
    final second = line2.trim().isEmpty ? '' : line2;
    return '$line1, $second, $city';
  }

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);
}

@Freezed(toJson: true, fromJson: true, copyWith: true)
abstract class PharmacyOrder with _$PharmacyOrder {
  const factory PharmacyOrder({
    required String orderId,
    required String userId,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
    required DeliveryAddress deliveryAddress,
    required PaymentMethod paymentMethod,
    required PaymentStatus paymentStatus,
    required OrderStatus orderStatus,
    required DateTime createdAt,
  }) = _PharmacyOrder;

  factory PharmacyOrder.fromJson(Map<String, dynamic> json) =>
      _$PharmacyOrderFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$PharmacyOrderToJson(this as _PharmacyOrder);
}
