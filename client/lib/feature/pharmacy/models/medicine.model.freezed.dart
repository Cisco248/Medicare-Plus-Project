// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicineModel {

 String get medicineName; MedicineCategory get category; int get dosage; double get price; String get imgPath;
/// Create a copy of MedicineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineModelCopyWith<MedicineModel> get copyWith => _$MedicineModelCopyWithImpl<MedicineModel>(this as MedicineModel, _$identity);

  /// Serializes this MedicineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicineModel&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.category, category) || other.category == category)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.price, price) || other.price == price)&&(identical(other.imgPath, imgPath) || other.imgPath == imgPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicineName,category,dosage,price,imgPath);

@override
String toString() {
  return 'MedicineModel(medicineName: $medicineName, category: $category, dosage: $dosage, price: $price, imgPath: $imgPath)';
}


}

/// @nodoc
abstract mixin class $MedicineModelCopyWith<$Res>  {
  factory $MedicineModelCopyWith(MedicineModel value, $Res Function(MedicineModel) _then) = _$MedicineModelCopyWithImpl;
@useResult
$Res call({
 String medicineName, MedicineCategory category, int dosage, double price, String imgPath
});




}
/// @nodoc
class _$MedicineModelCopyWithImpl<$Res>
    implements $MedicineModelCopyWith<$Res> {
  _$MedicineModelCopyWithImpl(this._self, this._then);

  final MedicineModel _self;
  final $Res Function(MedicineModel) _then;

/// Create a copy of MedicineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicineName = null,Object? category = null,Object? dosage = null,Object? price = null,Object? imgPath = null,}) {
  return _then(_self.copyWith(
medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MedicineCategory,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,imgPath: null == imgPath ? _self.imgPath : imgPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicineModel].
extension MedicineModelPatterns on MedicineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicineModel value)  $default,){
final _that = this;
switch (_that) {
case _MedicineModel():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicineModel value)?  $default,){
final _that = this;
switch (_that) {
case _MedicineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicineName,  MedicineCategory category,  int dosage,  double price,  String imgPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicineModel() when $default != null:
return $default(_that.medicineName,_that.category,_that.dosage,_that.price,_that.imgPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicineName,  MedicineCategory category,  int dosage,  double price,  String imgPath)  $default,) {final _that = this;
switch (_that) {
case _MedicineModel():
return $default(_that.medicineName,_that.category,_that.dosage,_that.price,_that.imgPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicineName,  MedicineCategory category,  int dosage,  double price,  String imgPath)?  $default,) {final _that = this;
switch (_that) {
case _MedicineModel() when $default != null:
return $default(_that.medicineName,_that.category,_that.dosage,_that.price,_that.imgPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicineModel implements MedicineModel {
  const _MedicineModel({required this.medicineName, required this.category, required this.dosage, required this.price, required this.imgPath});
  factory _MedicineModel.fromJson(Map<String, dynamic> json) => _$MedicineModelFromJson(json);

@override final  String medicineName;
@override final  MedicineCategory category;
@override final  int dosage;
@override final  double price;
@override final  String imgPath;

/// Create a copy of MedicineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineModelCopyWith<_MedicineModel> get copyWith => __$MedicineModelCopyWithImpl<_MedicineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicineModel&&(identical(other.medicineName, medicineName) || other.medicineName == medicineName)&&(identical(other.category, category) || other.category == category)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.price, price) || other.price == price)&&(identical(other.imgPath, imgPath) || other.imgPath == imgPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicineName,category,dosage,price,imgPath);

@override
String toString() {
  return 'MedicineModel(medicineName: $medicineName, category: $category, dosage: $dosage, price: $price, imgPath: $imgPath)';
}


}

/// @nodoc
abstract mixin class _$MedicineModelCopyWith<$Res> implements $MedicineModelCopyWith<$Res> {
  factory _$MedicineModelCopyWith(_MedicineModel value, $Res Function(_MedicineModel) _then) = __$MedicineModelCopyWithImpl;
@override @useResult
$Res call({
 String medicineName, MedicineCategory category, int dosage, double price, String imgPath
});




}
/// @nodoc
class __$MedicineModelCopyWithImpl<$Res>
    implements _$MedicineModelCopyWith<$Res> {
  __$MedicineModelCopyWithImpl(this._self, this._then);

  final _MedicineModel _self;
  final $Res Function(_MedicineModel) _then;

/// Create a copy of MedicineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicineName = null,Object? category = null,Object? dosage = null,Object? price = null,Object? imgPath = null,}) {
  return _then(_MedicineModel(
medicineName: null == medicineName ? _self.medicineName : medicineName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MedicineCategory,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,imgPath: null == imgPath ? _self.imgPath : imgPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
