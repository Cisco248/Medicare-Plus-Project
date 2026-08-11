// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FormStatus {

 FormType get status;
/// Create a copy of FormStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormStatusCopyWith<FormStatus> get copyWith => _$FormStatusCopyWithImpl<FormStatus>(this as FormStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormStatus&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'FormStatus(status: $status)';
}


}

/// @nodoc
abstract mixin class $FormStatusCopyWith<$Res>  {
  factory $FormStatusCopyWith(FormStatus value, $Res Function(FormStatus) _then) = _$FormStatusCopyWithImpl;
@useResult
$Res call({
 FormType status
});




}
/// @nodoc
class _$FormStatusCopyWithImpl<$Res>
    implements $FormStatusCopyWith<$Res> {
  _$FormStatusCopyWithImpl(this._self, this._then);

  final FormStatus _self;
  final $Res Function(FormStatus) _then;

/// Create a copy of FormStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormType,
  ));
}

}


/// Adds pattern-matching-related methods to [FormStatus].
extension FormStatusPatterns on FormStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormStatus value)  $default,){
final _that = this;
switch (_that) {
case _FormStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormStatus value)?  $default,){
final _that = this;
switch (_that) {
case _FormStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FormType status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormStatus() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FormType status)  $default,) {final _that = this;
switch (_that) {
case _FormStatus():
return $default(_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FormType status)?  $default,) {final _that = this;
switch (_that) {
case _FormStatus() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _FormStatus implements FormStatus {
  const _FormStatus({required this.status});
  

@override final  FormType status;

/// Create a copy of FormStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormStatusCopyWith<_FormStatus> get copyWith => __$FormStatusCopyWithImpl<_FormStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormStatus&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'FormStatus(status: $status)';
}


}

/// @nodoc
abstract mixin class _$FormStatusCopyWith<$Res> implements $FormStatusCopyWith<$Res> {
  factory _$FormStatusCopyWith(_FormStatus value, $Res Function(_FormStatus) _then) = __$FormStatusCopyWithImpl;
@override @useResult
$Res call({
 FormType status
});




}
/// @nodoc
class __$FormStatusCopyWithImpl<$Res>
    implements _$FormStatusCopyWith<$Res> {
  __$FormStatusCopyWithImpl(this._self, this._then);

  final _FormStatus _self;
  final $Res Function(_FormStatus) _then;

/// Create a copy of FormStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_FormStatus(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormType,
  ));
}


}

// dart format on
