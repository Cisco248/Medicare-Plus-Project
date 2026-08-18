// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diabetes.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiabetesModel {

 int get age; String get gender; double get pulseRate; String get bpReading; double get glucose; double get bmi; String get familyDiabetes; String get hypertensive;
/// Create a copy of DiabetesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiabetesModelCopyWith<DiabetesModel> get copyWith => _$DiabetesModelCopyWithImpl<DiabetesModel>(this as DiabetesModel, _$identity);

  /// Serializes this DiabetesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiabetesModel&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.pulseRate, pulseRate) || other.pulseRate == pulseRate)&&(identical(other.bpReading, bpReading) || other.bpReading == bpReading)&&(identical(other.glucose, glucose) || other.glucose == glucose)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.familyDiabetes, familyDiabetes) || other.familyDiabetes == familyDiabetes)&&(identical(other.hypertensive, hypertensive) || other.hypertensive == hypertensive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,age,gender,pulseRate,bpReading,glucose,bmi,familyDiabetes,hypertensive);

@override
String toString() {
  return 'DiabetesModel(age: $age, gender: $gender, pulseRate: $pulseRate, bpReading: $bpReading, glucose: $glucose, bmi: $bmi, familyDiabetes: $familyDiabetes, hypertensive: $hypertensive)';
}


}

/// @nodoc
abstract mixin class $DiabetesModelCopyWith<$Res>  {
  factory $DiabetesModelCopyWith(DiabetesModel value, $Res Function(DiabetesModel) _then) = _$DiabetesModelCopyWithImpl;
@useResult
$Res call({
 int age, String gender, double pulseRate, String bpReading, double glucose, double bmi, String familyDiabetes, String hypertensive
});




}
/// @nodoc
class _$DiabetesModelCopyWithImpl<$Res>
    implements $DiabetesModelCopyWith<$Res> {
  _$DiabetesModelCopyWithImpl(this._self, this._then);

  final DiabetesModel _self;
  final $Res Function(DiabetesModel) _then;

/// Create a copy of DiabetesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? age = null,Object? gender = null,Object? pulseRate = null,Object? bpReading = null,Object? glucose = null,Object? bmi = null,Object? familyDiabetes = null,Object? hypertensive = null,}) {
  return _then(_self.copyWith(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,pulseRate: null == pulseRate ? _self.pulseRate : pulseRate // ignore: cast_nullable_to_non_nullable
as double,bpReading: null == bpReading ? _self.bpReading : bpReading // ignore: cast_nullable_to_non_nullable
as String,glucose: null == glucose ? _self.glucose : glucose // ignore: cast_nullable_to_non_nullable
as double,bmi: null == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double,familyDiabetes: null == familyDiabetes ? _self.familyDiabetes : familyDiabetes // ignore: cast_nullable_to_non_nullable
as String,hypertensive: null == hypertensive ? _self.hypertensive : hypertensive // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiabetesModel].
extension DiabetesModelPatterns on DiabetesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiabetesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiabetesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiabetesModel value)  $default,){
final _that = this;
switch (_that) {
case _DiabetesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiabetesModel value)?  $default,){
final _that = this;
switch (_that) {
case _DiabetesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int age,  String gender,  double pulseRate,  String bpReading,  double glucose,  double bmi,  String familyDiabetes,  String hypertensive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiabetesModel() when $default != null:
return $default(_that.age,_that.gender,_that.pulseRate,_that.bpReading,_that.glucose,_that.bmi,_that.familyDiabetes,_that.hypertensive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int age,  String gender,  double pulseRate,  String bpReading,  double glucose,  double bmi,  String familyDiabetes,  String hypertensive)  $default,) {final _that = this;
switch (_that) {
case _DiabetesModel():
return $default(_that.age,_that.gender,_that.pulseRate,_that.bpReading,_that.glucose,_that.bmi,_that.familyDiabetes,_that.hypertensive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int age,  String gender,  double pulseRate,  String bpReading,  double glucose,  double bmi,  String familyDiabetes,  String hypertensive)?  $default,) {final _that = this;
switch (_that) {
case _DiabetesModel() when $default != null:
return $default(_that.age,_that.gender,_that.pulseRate,_that.bpReading,_that.glucose,_that.bmi,_that.familyDiabetes,_that.hypertensive);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _DiabetesModel implements DiabetesModel {
  const _DiabetesModel({required this.age, required this.gender, required this.pulseRate, required this.bpReading, required this.glucose, required this.bmi, required this.familyDiabetes, required this.hypertensive});
  factory _DiabetesModel.fromJson(Map<String, dynamic> json) => _$DiabetesModelFromJson(json);

@override final  int age;
@override final  String gender;
@override final  double pulseRate;
@override final  String bpReading;
@override final  double glucose;
@override final  double bmi;
@override final  String familyDiabetes;
@override final  String hypertensive;

/// Create a copy of DiabetesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiabetesModelCopyWith<_DiabetesModel> get copyWith => __$DiabetesModelCopyWithImpl<_DiabetesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiabetesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiabetesModel&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.pulseRate, pulseRate) || other.pulseRate == pulseRate)&&(identical(other.bpReading, bpReading) || other.bpReading == bpReading)&&(identical(other.glucose, glucose) || other.glucose == glucose)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.familyDiabetes, familyDiabetes) || other.familyDiabetes == familyDiabetes)&&(identical(other.hypertensive, hypertensive) || other.hypertensive == hypertensive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,age,gender,pulseRate,bpReading,glucose,bmi,familyDiabetes,hypertensive);

@override
String toString() {
  return 'DiabetesModel(age: $age, gender: $gender, pulseRate: $pulseRate, bpReading: $bpReading, glucose: $glucose, bmi: $bmi, familyDiabetes: $familyDiabetes, hypertensive: $hypertensive)';
}


}

/// @nodoc
abstract mixin class _$DiabetesModelCopyWith<$Res> implements $DiabetesModelCopyWith<$Res> {
  factory _$DiabetesModelCopyWith(_DiabetesModel value, $Res Function(_DiabetesModel) _then) = __$DiabetesModelCopyWithImpl;
@override @useResult
$Res call({
 int age, String gender, double pulseRate, String bpReading, double glucose, double bmi, String familyDiabetes, String hypertensive
});




}
/// @nodoc
class __$DiabetesModelCopyWithImpl<$Res>
    implements _$DiabetesModelCopyWith<$Res> {
  __$DiabetesModelCopyWithImpl(this._self, this._then);

  final _DiabetesModel _self;
  final $Res Function(_DiabetesModel) _then;

/// Create a copy of DiabetesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? age = null,Object? gender = null,Object? pulseRate = null,Object? bpReading = null,Object? glucose = null,Object? bmi = null,Object? familyDiabetes = null,Object? hypertensive = null,}) {
  return _then(_DiabetesModel(
age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,pulseRate: null == pulseRate ? _self.pulseRate : pulseRate // ignore: cast_nullable_to_non_nullable
as double,bpReading: null == bpReading ? _self.bpReading : bpReading // ignore: cast_nullable_to_non_nullable
as String,glucose: null == glucose ? _self.glucose : glucose // ignore: cast_nullable_to_non_nullable
as double,bmi: null == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double,familyDiabetes: null == familyDiabetes ? _self.familyDiabetes : familyDiabetes // ignore: cast_nullable_to_non_nullable
as String,hypertensive: null == hypertensive ? _self.hypertensive : hypertensive // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
