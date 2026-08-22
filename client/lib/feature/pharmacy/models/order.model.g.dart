// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) =>
    _DeliveryAddress(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String? ?? '',
      city: json['city'] as String,
    );

Map<String, dynamic> _$DeliveryAddressToJson(_DeliveryAddress instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'line1': instance.line1,
      'line2': instance.line2,
      'city': instance.city,
    };

_PharmacyOrder _$PharmacyOrderFromJson(Map<String, dynamic> json) =>
    _PharmacyOrder(
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: DeliveryAddress.fromJson(
        json['deliveryAddress'] as Map<String, dynamic>,
      ),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      orderStatus: $enumDecode(_$OrderStatusEnumMap, json['orderStatus']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PharmacyOrderToJson(_PharmacyOrder instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'userId': instance.userId,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'discount': instance.discount,
      'total': instance.total,
      'deliveryAddress': instance.deliveryAddress,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'orderStatus': _$OrderStatusEnumMap[instance.orderStatus]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cashOnDelivery: 'cashOnDelivery',
  PaymentMethod.demoCard: 'demoCard',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.successful: 'successful',
  PaymentStatus.failed: 'failed',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.outForDelivery: 'outForDelivery',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};
