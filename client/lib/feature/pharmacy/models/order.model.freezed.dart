// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryAddress {

 String get fullName; String get phone; String get line1; String get line2; String get city;
/// Create a copy of DeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryAddressCopyWith<DeliveryAddress> get copyWith => _$DeliveryAddressCopyWithImpl<DeliveryAddress>(this as DeliveryAddress, _$identity);

  /// Serializes this DeliveryAddress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryAddress&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,phone,line1,line2,city);

@override
String toString() {
  return 'DeliveryAddress(fullName: $fullName, phone: $phone, line1: $line1, line2: $line2, city: $city)';
}


}

/// @nodoc
abstract mixin class $DeliveryAddressCopyWith<$Res>  {
  factory $DeliveryAddressCopyWith(DeliveryAddress value, $Res Function(DeliveryAddress) _then) = _$DeliveryAddressCopyWithImpl;
@useResult
$Res call({
 String fullName, String phone, String line1, String line2, String city
});




}
/// @nodoc
class _$DeliveryAddressCopyWithImpl<$Res>
    implements $DeliveryAddressCopyWith<$Res> {
  _$DeliveryAddressCopyWithImpl(this._self, this._then);

  final DeliveryAddress _self;
  final $Res Function(DeliveryAddress) _then;

/// Create a copy of DeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? phone = null,Object? line1 = null,Object? line2 = null,Object? city = null,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: null == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryAddress].
extension DeliveryAddressPatterns on DeliveryAddress {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryAddress() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryAddress value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryAddress():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryAddress value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryAddress() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String phone,  String line1,  String line2,  String city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryAddress() when $default != null:
return $default(_that.fullName,_that.phone,_that.line1,_that.line2,_that.city);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String phone,  String line1,  String line2,  String city)  $default,) {final _that = this;
switch (_that) {
case _DeliveryAddress():
return $default(_that.fullName,_that.phone,_that.line1,_that.line2,_that.city);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String phone,  String line1,  String line2,  String city)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryAddress() when $default != null:
return $default(_that.fullName,_that.phone,_that.line1,_that.line2,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryAddress extends DeliveryAddress {
  const _DeliveryAddress({required this.fullName, required this.phone, required this.line1, this.line2 = '', required this.city}): super._();
  factory _DeliveryAddress.fromJson(Map<String, dynamic> json) => _$DeliveryAddressFromJson(json);

@override final  String fullName;
@override final  String phone;
@override final  String line1;
@override@JsonKey() final  String line2;
@override final  String city;

/// Create a copy of DeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryAddressCopyWith<_DeliveryAddress> get copyWith => __$DeliveryAddressCopyWithImpl<_DeliveryAddress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryAddressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryAddress&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,phone,line1,line2,city);

@override
String toString() {
  return 'DeliveryAddress(fullName: $fullName, phone: $phone, line1: $line1, line2: $line2, city: $city)';
}


}

/// @nodoc
abstract mixin class _$DeliveryAddressCopyWith<$Res> implements $DeliveryAddressCopyWith<$Res> {
  factory _$DeliveryAddressCopyWith(_DeliveryAddress value, $Res Function(_DeliveryAddress) _then) = __$DeliveryAddressCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String phone, String line1, String line2, String city
});




}
/// @nodoc
class __$DeliveryAddressCopyWithImpl<$Res>
    implements _$DeliveryAddressCopyWith<$Res> {
  __$DeliveryAddressCopyWithImpl(this._self, this._then);

  final _DeliveryAddress _self;
  final $Res Function(_DeliveryAddress) _then;

/// Create a copy of DeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? phone = null,Object? line1 = null,Object? line2 = null,Object? city = null,}) {
  return _then(_DeliveryAddress(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: null == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PharmacyOrder {

 String get orderId; String get userId; List<CartItem> get items; double get subtotal; double get deliveryFee; double get discount; double get total; DeliveryAddress get deliveryAddress; PaymentMethod get paymentMethod; PaymentStatus get paymentStatus; OrderStatus get orderStatus; DateTime get createdAt;
/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyOrderCopyWith<PharmacyOrder> get copyWith => _$PharmacyOrderCopyWithImpl<PharmacyOrder>(this as PharmacyOrder, _$identity);

  /// Serializes this PharmacyOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.orderStatus, orderStatus) || other.orderStatus == orderStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,userId,const DeepCollectionEquality().hash(items),subtotal,deliveryFee,discount,total,deliveryAddress,paymentMethod,paymentStatus,orderStatus,createdAt);

@override
String toString() {
  return 'PharmacyOrder(orderId: $orderId, userId: $userId, items: $items, subtotal: $subtotal, deliveryFee: $deliveryFee, discount: $discount, total: $total, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, orderStatus: $orderStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PharmacyOrderCopyWith<$Res>  {
  factory $PharmacyOrderCopyWith(PharmacyOrder value, $Res Function(PharmacyOrder) _then) = _$PharmacyOrderCopyWithImpl;
@useResult
$Res call({
 String orderId, String userId, List<CartItem> items, double subtotal, double deliveryFee, double discount, double total, DeliveryAddress deliveryAddress, PaymentMethod paymentMethod, PaymentStatus paymentStatus, OrderStatus orderStatus, DateTime createdAt
});


$DeliveryAddressCopyWith<$Res> get deliveryAddress;

}
/// @nodoc
class _$PharmacyOrderCopyWithImpl<$Res>
    implements $PharmacyOrderCopyWith<$Res> {
  _$PharmacyOrderCopyWithImpl(this._self, this._then);

  final PharmacyOrder _self;
  final $Res Function(PharmacyOrder) _then;

/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? userId = null,Object? items = null,Object? subtotal = null,Object? deliveryFee = null,Object? discount = null,Object? total = null,Object? deliveryAddress = null,Object? paymentMethod = null,Object? paymentStatus = null,Object? orderStatus = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as DeliveryAddress,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,orderStatus: null == orderStatus ? _self.orderStatus : orderStatus // ignore: cast_nullable_to_non_nullable
as OrderStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryAddressCopyWith<$Res> get deliveryAddress {
  
  return $DeliveryAddressCopyWith<$Res>(_self.deliveryAddress, (value) {
    return _then(_self.copyWith(deliveryAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [PharmacyOrder].
extension PharmacyOrderPatterns on PharmacyOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PharmacyOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PharmacyOrder value)  $default,){
final _that = this;
switch (_that) {
case _PharmacyOrder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PharmacyOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String userId,  List<CartItem> items,  double subtotal,  double deliveryFee,  double discount,  double total,  DeliveryAddress deliveryAddress,  PaymentMethod paymentMethod,  PaymentStatus paymentStatus,  OrderStatus orderStatus,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that.orderId,_that.userId,_that.items,_that.subtotal,_that.deliveryFee,_that.discount,_that.total,_that.deliveryAddress,_that.paymentMethod,_that.paymentStatus,_that.orderStatus,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String userId,  List<CartItem> items,  double subtotal,  double deliveryFee,  double discount,  double total,  DeliveryAddress deliveryAddress,  PaymentMethod paymentMethod,  PaymentStatus paymentStatus,  OrderStatus orderStatus,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PharmacyOrder():
return $default(_that.orderId,_that.userId,_that.items,_that.subtotal,_that.deliveryFee,_that.discount,_that.total,_that.deliveryAddress,_that.paymentMethod,_that.paymentStatus,_that.orderStatus,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String userId,  List<CartItem> items,  double subtotal,  double deliveryFee,  double discount,  double total,  DeliveryAddress deliveryAddress,  PaymentMethod paymentMethod,  PaymentStatus paymentStatus,  OrderStatus orderStatus,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyOrder() when $default != null:
return $default(_that.orderId,_that.userId,_that.items,_that.subtotal,_that.deliveryFee,_that.discount,_that.total,_that.deliveryAddress,_that.paymentMethod,_that.paymentStatus,_that.orderStatus,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PharmacyOrder implements PharmacyOrder {
  const _PharmacyOrder({required this.orderId, required this.userId, required final  List<CartItem> items, required this.subtotal, required this.deliveryFee, required this.discount, required this.total, required this.deliveryAddress, required this.paymentMethod, required this.paymentStatus, required this.orderStatus, required this.createdAt}): _items = items;
  factory _PharmacyOrder.fromJson(Map<String, dynamic> json) => _$PharmacyOrderFromJson(json);

@override final  String orderId;
@override final  String userId;
 final  List<CartItem> _items;
@override List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double subtotal;
@override final  double deliveryFee;
@override final  double discount;
@override final  double total;
@override final  DeliveryAddress deliveryAddress;
@override final  PaymentMethod paymentMethod;
@override final  PaymentStatus paymentStatus;
@override final  OrderStatus orderStatus;
@override final  DateTime createdAt;

/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyOrderCopyWith<_PharmacyOrder> get copyWith => __$PharmacyOrderCopyWithImpl<_PharmacyOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PharmacyOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.orderStatus, orderStatus) || other.orderStatus == orderStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,userId,const DeepCollectionEquality().hash(_items),subtotal,deliveryFee,discount,total,deliveryAddress,paymentMethod,paymentStatus,orderStatus,createdAt);

@override
String toString() {
  return 'PharmacyOrder(orderId: $orderId, userId: $userId, items: $items, subtotal: $subtotal, deliveryFee: $deliveryFee, discount: $discount, total: $total, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, orderStatus: $orderStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PharmacyOrderCopyWith<$Res> implements $PharmacyOrderCopyWith<$Res> {
  factory _$PharmacyOrderCopyWith(_PharmacyOrder value, $Res Function(_PharmacyOrder) _then) = __$PharmacyOrderCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String userId, List<CartItem> items, double subtotal, double deliveryFee, double discount, double total, DeliveryAddress deliveryAddress, PaymentMethod paymentMethod, PaymentStatus paymentStatus, OrderStatus orderStatus, DateTime createdAt
});


@override $DeliveryAddressCopyWith<$Res> get deliveryAddress;

}
/// @nodoc
class __$PharmacyOrderCopyWithImpl<$Res>
    implements _$PharmacyOrderCopyWith<$Res> {
  __$PharmacyOrderCopyWithImpl(this._self, this._then);

  final _PharmacyOrder _self;
  final $Res Function(_PharmacyOrder) _then;

/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? userId = null,Object? items = null,Object? subtotal = null,Object? deliveryFee = null,Object? discount = null,Object? total = null,Object? deliveryAddress = null,Object? paymentMethod = null,Object? paymentStatus = null,Object? orderStatus = null,Object? createdAt = null,}) {
  return _then(_PharmacyOrder(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as DeliveryAddress,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,orderStatus: null == orderStatus ? _self.orderStatus : orderStatus // ignore: cast_nullable_to_non_nullable
as OrderStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of PharmacyOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryAddressCopyWith<$Res> get deliveryAddress {
  
  return $DeliveryAddressCopyWith<$Res>(_self.deliveryAddress, (value) {
    return _then(_self.copyWith(deliveryAddress: value));
  });
}
}

// dart format on
