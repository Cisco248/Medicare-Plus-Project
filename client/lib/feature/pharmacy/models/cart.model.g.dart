// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  product: PharmacyProduct.fromJson(json['product'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'product': instance.product,
  'quantity': instance.quantity,
};

_CartState _$CartStateFromJson(Map<String, dynamic> json) => _CartState(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CartStateToJson(_CartState instance) =>
    <String, dynamic>{'items': instance.items};
