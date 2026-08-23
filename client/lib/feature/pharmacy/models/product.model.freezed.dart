// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PharmacyProduct {

 String get id; String get name; String get brand; ProductCategory get category; String get description; double get price; String get imgPath; double get discount; bool get inStock; int get stockCount; bool get prescriptionRequired; String get usage; String get warnings; int get popularity;
/// Create a copy of PharmacyProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyProductCopyWith<PharmacyProduct> get copyWith => _$PharmacyProductCopyWithImpl<PharmacyProduct>(this as PharmacyProduct, _$identity);

  /// Serializes this PharmacyProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.imgPath, imgPath) || other.imgPath == imgPath)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.inStock, inStock) || other.inStock == inStock)&&(identical(other.stockCount, stockCount) || other.stockCount == stockCount)&&(identical(other.prescriptionRequired, prescriptionRequired) || other.prescriptionRequired == prescriptionRequired)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.warnings, warnings) || other.warnings == warnings)&&(identical(other.popularity, popularity) || other.popularity == popularity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,brand,category,description,price,imgPath,discount,inStock,stockCount,prescriptionRequired,usage,warnings,popularity);

@override
String toString() {
  return 'PharmacyProduct(id: $id, name: $name, brand: $brand, category: $category, description: $description, price: $price, imgPath: $imgPath, discount: $discount, inStock: $inStock, stockCount: $stockCount, prescriptionRequired: $prescriptionRequired, usage: $usage, warnings: $warnings, popularity: $popularity)';
}


}

/// @nodoc
abstract mixin class $PharmacyProductCopyWith<$Res>  {
  factory $PharmacyProductCopyWith(PharmacyProduct value, $Res Function(PharmacyProduct) _then) = _$PharmacyProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String brand, ProductCategory category, String description, double price, String imgPath, double discount, bool inStock, int stockCount, bool prescriptionRequired, String usage, String warnings, int popularity
});




}
/// @nodoc
class _$PharmacyProductCopyWithImpl<$Res>
    implements $PharmacyProductCopyWith<$Res> {
  _$PharmacyProductCopyWithImpl(this._self, this._then);

  final PharmacyProduct _self;
  final $Res Function(PharmacyProduct) _then;

/// Create a copy of PharmacyProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? price = null,Object? imgPath = null,Object? discount = null,Object? inStock = null,Object? stockCount = null,Object? prescriptionRequired = null,Object? usage = null,Object? warnings = null,Object? popularity = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,imgPath: null == imgPath ? _self.imgPath : imgPath // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,inStock: null == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as bool,stockCount: null == stockCount ? _self.stockCount : stockCount // ignore: cast_nullable_to_non_nullable
as int,prescriptionRequired: null == prescriptionRequired ? _self.prescriptionRequired : prescriptionRequired // ignore: cast_nullable_to_non_nullable
as bool,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as String,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PharmacyProduct].
extension PharmacyProductPatterns on PharmacyProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PharmacyProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PharmacyProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PharmacyProduct value)  $default,){
final _that = this;
switch (_that) {
case _PharmacyProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PharmacyProduct value)?  $default,){
final _that = this;
switch (_that) {
case _PharmacyProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  ProductCategory category,  String description,  double price,  String imgPath,  double discount,  bool inStock,  int stockCount,  bool prescriptionRequired,  String usage,  String warnings,  int popularity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyProduct() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.price,_that.imgPath,_that.discount,_that.inStock,_that.stockCount,_that.prescriptionRequired,_that.usage,_that.warnings,_that.popularity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  ProductCategory category,  String description,  double price,  String imgPath,  double discount,  bool inStock,  int stockCount,  bool prescriptionRequired,  String usage,  String warnings,  int popularity)  $default,) {final _that = this;
switch (_that) {
case _PharmacyProduct():
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.price,_that.imgPath,_that.discount,_that.inStock,_that.stockCount,_that.prescriptionRequired,_that.usage,_that.warnings,_that.popularity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String brand,  ProductCategory category,  String description,  double price,  String imgPath,  double discount,  bool inStock,  int stockCount,  bool prescriptionRequired,  String usage,  String warnings,  int popularity)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyProduct() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.price,_that.imgPath,_that.discount,_that.inStock,_that.stockCount,_that.prescriptionRequired,_that.usage,_that.warnings,_that.popularity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PharmacyProduct extends PharmacyProduct {
  const _PharmacyProduct({required this.id, required this.name, required this.brand, required this.category, required this.description, required this.price, required this.imgPath, this.discount = 0.0, this.inStock = true, this.stockCount = 20, this.prescriptionRequired = true, this.usage = '', this.warnings = '', this.popularity = 0}): super._();
  factory _PharmacyProduct.fromJson(Map<String, dynamic> json,) => _$PharmacyProductFromJson(json,);

@override final  String id;
@override final  String name;
@override final  String brand;
@override final  ProductCategory category;
@override final  String description;
@override final  double price;
@override final  String imgPath;
@override@JsonKey() final  double discount;
@override@JsonKey() final  bool inStock;
@override@JsonKey() final  int stockCount;
@override@JsonKey() final  bool prescriptionRequired;
@override@JsonKey() final  String usage;
@override@JsonKey() final  String warnings;
@override@JsonKey() final  int popularity;

/// Create a copy of PharmacyProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyProductCopyWith<_PharmacyProduct> get copyWith => __$PharmacyProductCopyWithImpl<_PharmacyProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PharmacyProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.imgPath, imgPath) || other.imgPath == imgPath)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.inStock, inStock) || other.inStock == inStock)&&(identical(other.stockCount, stockCount) || other.stockCount == stockCount)&&(identical(other.prescriptionRequired, prescriptionRequired) || other.prescriptionRequired == prescriptionRequired)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.warnings, warnings) || other.warnings == warnings)&&(identical(other.popularity, popularity) || other.popularity == popularity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,brand,category,description,price,imgPath,discount,inStock,stockCount,prescriptionRequired,usage,warnings,popularity);

@override
String toString() {
  return 'PharmacyProduct(id: $id, name: $name, brand: $brand, category: $category, description: $description, price: $price, imgPath: $imgPath, discount: $discount, inStock: $inStock, stockCount: $stockCount, prescriptionRequired: $prescriptionRequired, usage: $usage, warnings: $warnings, popularity: $popularity)';
}


}

/// @nodoc
abstract mixin class _$PharmacyProductCopyWith<$Res> implements $PharmacyProductCopyWith<$Res> {
  factory _$PharmacyProductCopyWith(_PharmacyProduct value, $Res Function(_PharmacyProduct) _then) = __$PharmacyProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String brand, ProductCategory category, String description, double price, String imgPath, double discount, bool inStock, int stockCount, bool prescriptionRequired, String usage, String warnings, int popularity
});




}
/// @nodoc
class __$PharmacyProductCopyWithImpl<$Res>
    implements _$PharmacyProductCopyWith<$Res> {
  __$PharmacyProductCopyWithImpl(this._self, this._then);

  final _PharmacyProduct _self;
  final $Res Function(_PharmacyProduct) _then;

/// Create a copy of PharmacyProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? price = null,Object? imgPath = null,Object? discount = null,Object? inStock = null,Object? stockCount = null,Object? prescriptionRequired = null,Object? usage = null,Object? warnings = null,Object? popularity = null,}) {
  return _then(_PharmacyProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,imgPath: null == imgPath ? _self.imgPath : imgPath // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,inStock: null == inStock ? _self.inStock : inStock // ignore: cast_nullable_to_non_nullable
as bool,stockCount: null == stockCount ? _self.stockCount : stockCount // ignore: cast_nullable_to_non_nullable
as int,prescriptionRequired: null == prescriptionRequired ? _self.prescriptionRequired : prescriptionRequired // ignore: cast_nullable_to_non_nullable
as bool,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as String,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
