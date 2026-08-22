// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pharma_query.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PharmacyQuery {

 String get search; ProductCategory? get category; double? get minPrice; double? get maxPrice; ProductSort get sort;
/// Create a copy of PharmacyQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyQueryCopyWith<PharmacyQuery> get copyWith => _$PharmacyQueryCopyWithImpl<PharmacyQuery>(this as PharmacyQuery, _$identity);

  /// Serializes this PharmacyQuery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.category, category) || other.category == category)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.sort, sort) || other.sort == sort));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,search,category,minPrice,maxPrice,sort);

@override
String toString() {
  return 'PharmacyQuery(search: $search, category: $category, minPrice: $minPrice, maxPrice: $maxPrice, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $PharmacyQueryCopyWith<$Res>  {
  factory $PharmacyQueryCopyWith(PharmacyQuery value, $Res Function(PharmacyQuery) _then) = _$PharmacyQueryCopyWithImpl;
@useResult
$Res call({
 String search, ProductCategory? category, double? minPrice, double? maxPrice, ProductSort sort
});




}
/// @nodoc
class _$PharmacyQueryCopyWithImpl<$Res>
    implements $PharmacyQueryCopyWith<$Res> {
  _$PharmacyQueryCopyWithImpl(this._self, this._then);

  final PharmacyQuery _self;
  final $Res Function(PharmacyQuery) _then;

/// Create a copy of PharmacyQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? category = freezed,Object? minPrice = freezed,Object? maxPrice = freezed,Object? sort = null,}) {
  return _then(_self.copyWith(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory?,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ProductSort,
  ));
}

}


/// Adds pattern-matching-related methods to [PharmacyQuery].
extension PharmacyQueryPatterns on PharmacyQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PharmacyQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PharmacyQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PharmacyQuery value)  $default,){
final _that = this;
switch (_that) {
case _PharmacyQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PharmacyQuery value)?  $default,){
final _that = this;
switch (_that) {
case _PharmacyQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  ProductCategory? category,  double? minPrice,  double? maxPrice,  ProductSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyQuery() when $default != null:
return $default(_that.search,_that.category,_that.minPrice,_that.maxPrice,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  ProductCategory? category,  double? minPrice,  double? maxPrice,  ProductSort sort)  $default,) {final _that = this;
switch (_that) {
case _PharmacyQuery():
return $default(_that.search,_that.category,_that.minPrice,_that.maxPrice,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  ProductCategory? category,  double? minPrice,  double? maxPrice,  ProductSort sort)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyQuery() when $default != null:
return $default(_that.search,_that.category,_that.minPrice,_that.maxPrice,_that.sort);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PharmacyQuery extends PharmacyQuery {
  const _PharmacyQuery({this.search = '', this.category = ProductCategory.firstAid, this.minPrice = 0.0, this.maxPrice = 0.0, this.sort = ProductSort.name}): super._();
  factory _PharmacyQuery.fromJson(Map<String, dynamic> json,) => _$PharmacyQueryFromJson(json,);

@override@JsonKey() final  String search;
@override@JsonKey() final  ProductCategory? category;
@override@JsonKey() final  double? minPrice;
@override@JsonKey() final  double? maxPrice;
@override@JsonKey() final  ProductSort sort;

/// Create a copy of PharmacyQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyQueryCopyWith<_PharmacyQuery> get copyWith => __$PharmacyQueryCopyWithImpl<_PharmacyQuery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PharmacyQueryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.category, category) || other.category == category)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.sort, sort) || other.sort == sort));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,search,category,minPrice,maxPrice,sort);

@override
String toString() {
  return 'PharmacyQuery(search: $search, category: $category, minPrice: $minPrice, maxPrice: $maxPrice, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$PharmacyQueryCopyWith<$Res> implements $PharmacyQueryCopyWith<$Res> {
  factory _$PharmacyQueryCopyWith(_PharmacyQuery value, $Res Function(_PharmacyQuery) _then) = __$PharmacyQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, ProductCategory? category, double? minPrice, double? maxPrice, ProductSort sort
});




}
/// @nodoc
class __$PharmacyQueryCopyWithImpl<$Res>
    implements _$PharmacyQueryCopyWith<$Res> {
  __$PharmacyQueryCopyWithImpl(this._self, this._then);

  final _PharmacyQuery _self;
  final $Res Function(_PharmacyQuery) _then;

/// Create a copy of PharmacyQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? category = freezed,Object? minPrice = freezed,Object? maxPrice = freezed,Object? sort = null,}) {
  return _then(_PharmacyQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory?,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ProductSort,
  ));
}


}

// dart format on
