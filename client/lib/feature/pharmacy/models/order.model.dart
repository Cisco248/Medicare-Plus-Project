import 'package:client/feature/pharmacy/models/cart.model.dart';

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

class DeliveryAddress {
  const DeliveryAddress({
    required this.fullName,
    required this.phone,
    required this.line1,
    this.line2 = '',
    required this.city,
  });

  final String fullName;
  final String phone;
  final String line1;
  final String line2;
  final String city;

  String get formatted {
    final second = line2.trim().isEmpty ? '' : '$line2, ';
    return '$line1, $second$city';
  }

  Map<String, Object?> toJson() => {
    'fullName': fullName,
    'phone': phone,
    'line1': line1,
    'line2': line2,
    'city': city,
  };

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        fullName: json['fullName'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        line1: json['line1'] as String? ?? '',
        line2: json['line2'] as String? ?? '',
        city: json['city'] as String? ?? '',
      );
}

class PharmacyOrder {
  const PharmacyOrder({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
  });

  final String orderId;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final DeliveryAddress deliveryAddress;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final DateTime createdAt;

  PharmacyOrder copyWith({
    PaymentStatus? paymentStatus,
    OrderStatus? orderStatus,
  }) {
    return PharmacyOrder(
      orderId: orderId,
      userId: userId,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() => {
    'orderId': orderId,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'discount': discount,
    'total': total,
    'deliveryAddress': deliveryAddress.toJson(),
    'paymentMethod': paymentMethod.name,
    'paymentStatus': paymentStatus.name,
    'orderStatus': orderStatus.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PharmacyOrder.fromJson(Map<String, dynamic> json) => PharmacyOrder(
    orderId: json['orderId'] as String,
    userId: json['userId'] as String? ?? '',
    items: ((json['items'] as List<dynamic>?) ?? const [])
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList(),
    subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
    deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
    discount: (json['discount'] as num?)?.toDouble() ?? 0,
    total: (json['total'] as num?)?.toDouble() ?? 0,
    deliveryAddress: DeliveryAddress.fromJson(
      json['deliveryAddress'] as Map<String, dynamic>? ?? const {},
    ),
    paymentMethod: PaymentMethod.values.firstWhere(
      (value) => value.name == json['paymentMethod'],
      orElse: () => PaymentMethod.cashOnDelivery,
    ),
    paymentStatus: PaymentStatus.values.firstWhere(
      (value) => value.name == json['paymentStatus'],
      orElse: () => PaymentStatus.pending,
    ),
    orderStatus: OrderStatus.values.firstWhere(
      (value) => value.name == json['orderStatus'],
      orElse: () => OrderStatus.pending,
    ),
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
        DateTime.now(),
  );
}
