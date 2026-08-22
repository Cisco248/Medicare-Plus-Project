// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hypertension.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HypertensionModel {

 int get age; double get height; double get weight; double get hba1c;@JsonKey(name: 'cholesterol_mgdl') double get cholesterolMgdl; DiabetesOrdinal get diabetesOrdinal; Gender get gender;
/// Create a copy of HypertensionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HypertensionModelCopyWith<HypertensionModel> get copyWith => _$HypertensionModelCopyWithImpl<HypertensionModel>(this as HypertensionModel, _$identity);

  /// Serializes this HypertensionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HypertensionModel&&(identical(other.age, age) || other.age == age)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.hba1c, hba1c) || other.hba1c == hba1c)&&(identical(other.cholesterolMgdl, cholesterolMgdl) || other.cholesterolMgdl == cholesterolMgdl)&&(identical(other.diabetesOrdinal, diabetesOrdinal) || other.diabetesOrdinal == diabetesOrdinal)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,age,height,weight,hba1c,cholesterolMgdl,diabetesOrdinal,gender);

@override
String toString() {
  return 'HypertensionModel(age: $age, height: $height, weight: $weight, hba1c: $hba1c, cholesterolMgdl: $cholesterolMgdl, diabetesOrdinal: $diabetesOrdinal, gender: $gender)';
}


}

/// @nodoc
abstract mixin class $HypertensionModelCopyWith<$Res>  {
  factory $HypertensionModelCopyWith(HypertensionModel value, $Res Function(HypertensionModel) _then) = _$HypertensionModelCopyWithImpl;
@useResult
$Res call({
 int age, double height, double weight, double hba1c,@JsonKey(name: 'cholesterol_mgdl') double cholesterolMgdl, DiabetesOrdinal diabetesOrdinal, Gender gender
});




}
/// @nodoc
class _$HypertensionModelCopyWithImpl<$Res>
    implements $HypertensionModelCopyWith<$Res> {
  _$HypertensionModelCopyWithImpl(this._self, this._then);

  final HypertensionModel _self;
  final $Res Function(HypertensionModel) _then;

/// Create a copy of HypertensionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? age = null,Object? height = null,Object? weight = null,Object? hba1c = null,Object? cholesterolMgdl = null,Object? diabetesOrdinal = null,Object? gender = null,}) {
  return _then(_self.copyWith(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,hba1c: null == hba1c ? _self.hba1c : hba1c // ignore: cast_nullable_to_non_nullable
as double,cholesterolMgdl: null == cholesterolMgdl ? _self.cholesterolMgdl : cholesterolMgdl // ignore: cast_nullable_to_non_nullable
as double,diabetesOrdinal: null == diabetesOrdinal ? _self.diabetesOrdinal : diabetesOrdinal // ignore: cast_nullable_to_non_nullable
as DiabetesOrdinal,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,
  ));
}

}


/// Adds pattern-matching-related methods to [HypertensionModel].
extension HypertensionModelPatterns on HypertensionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HypertensionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HypertensionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HypertensionModel value)  $default,){
final _that = this;
switch (_that) {
case _HypertensionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HypertensionModel value)?  $default,){
final _that = this;
switch (_that) {
case _HypertensionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int age,  double height,  double weight,  double hba1c, @JsonKey(name: 'cholesterol_mgdl')  double cholesterolMgdl,  DiabetesOrdinal diabetesOrdinal,  Gender gender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HypertensionModel() when $default != null:
return $default(_that.age,_that.height,_that.weight,_that.hba1c,_that.cholesterolMgdl,_that.diabetesOrdinal,_that.gender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int age,  double height,  double weight,  double hba1c, @JsonKey(name: 'cholesterol_mgdl')  double cholesterolMgdl,  DiabetesOrdinal diabetesOrdinal,  Gender gender)  $default,) {final _that = this;
switch (_that) {
case _HypertensionModel():
return $default(_that.age,_that.height,_that.weight,_that.hba1c,_that.cholesterolMgdl,_that.diabetesOrdinal,_that.gender);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int age,  double height,  double weight,  double hba1c, @JsonKey(name: 'cholesterol_mgdl')  double cholesterolMgdl,  DiabetesOrdinal diabetesOrdinal,  Gender gender)?  $default,) {final _that = this;
switch (_that) {
case _HypertensionModel() when $default != null:
return $default(_that.age,_that.height,_that.weight,_that.hba1c,_that.cholesterolMgdl,_that.diabetesOrdinal,_that.gender);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _HypertensionModel implements HypertensionModel {
  const _HypertensionModel({required this.age, required this.height, required this.weight, required this.hba1c, @JsonKey(name: 'cholesterol_mgdl') required this.cholesterolMgdl, required this.diabetesOrdinal, required this.gender});
  factory _HypertensionModel.fromJson(Map<String, dynamic> json) => _$HypertensionModelFromJson(json);

@override final  int age;
@override final  double height;
@override final  double weight;
@override final  double hba1c;
@override@JsonKey(name: 'cholesterol_mgdl') final  double cholesterolMgdl;
@override final  DiabetesOrdinal diabetesOrdinal;
@override final  Gender gender;

/// Create a copy of HypertensionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HypertensionModelCopyWith<_HypertensionModel> get copyWith => __$HypertensionModelCopyWithImpl<_HypertensionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HypertensionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HypertensionModel&&(identical(other.age, age) || other.age == age)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.hba1c, hba1c) || other.hba1c == hba1c)&&(identical(other.cholesterolMgdl, cholesterolMgdl) || other.cholesterolMgdl == cholesterolMgdl)&&(identical(other.diabetesOrdinal, diabetesOrdinal) || other.diabetesOrdinal == diabetesOrdinal)&&(identical(other.gender, gender) || other.gender == gender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,age,height,weight,hba1c,cholesterolMgdl,diabetesOrdinal,gender);

@override
String toString() {
  return 'HypertensionModel(age: $age, height: $height, weight: $weight, hba1c: $hba1c, cholesterolMgdl: $cholesterolMgdl, diabetesOrdinal: $diabetesOrdinal, gender: $gender)';
}


}

/// @nodoc
abstract mixin class _$HypertensionModelCopyWith<$Res> implements $HypertensionModelCopyWith<$Res> {
  factory _$HypertensionModelCopyWith(_HypertensionModel value, $Res Function(_HypertensionModel) _then) = __$HypertensionModelCopyWithImpl;
@override @useResult
$Res call({
 int age, double height, double weight, double hba1c,@JsonKey(name: 'cholesterol_mgdl') double cholesterolMgdl, DiabetesOrdinal diabetesOrdinal, Gender gender
});




}
/// @nodoc
class __$HypertensionModelCopyWithImpl<$Res>
    implements _$HypertensionModelCopyWith<$Res> {
  __$HypertensionModelCopyWithImpl(this._self, this._then);

  final _HypertensionModel _self;
  final $Res Function(_HypertensionModel) _then;

/// Create a copy of HypertensionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? age = null,Object? height = null,Object? weight = null,Object? hba1c = null,Object? cholesterolMgdl = null,Object? diabetesOrdinal = null,Object? gender = null,}) {
  return _then(_HypertensionModel(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,hba1c: null == hba1c ? _self.hba1c : hba1c // ignore: cast_nullable_to_non_nullable
as double,cholesterolMgdl: null == cholesterolMgdl ? _self.cholesterolMgdl : cholesterolMgdl // ignore: cast_nullable_to_non_nullable
as double,diabetesOrdinal: null == diabetesOrdinal ? _self.diabetesOrdinal : diabetesOrdinal // ignore: cast_nullable_to_non_nullable
as DiabetesOrdinal,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,
  ));
}


}

// dart format on
