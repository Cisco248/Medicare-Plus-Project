// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthStatus {

 AuthMode get state; UserModel? get data; String? get token;
/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStatusCopyWith<AuthStatus> get copyWith => _$AuthStatusCopyWithImpl<AuthStatus>(this as AuthStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStatus&&(identical(other.state, state) || other.state == state)&&(identical(other.data, data) || other.data == data)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,state,data,token);

@override
String toString() {
  return 'AuthStatus(state: $state, data: $data, token: $token)';
}


}

/// @nodoc
abstract mixin class $AuthStatusCopyWith<$Res>  {
  factory $AuthStatusCopyWith(AuthStatus value, $Res Function(AuthStatus) _then) = _$AuthStatusCopyWithImpl;
@useResult
$Res call({
 AuthMode state, UserModel? data, String? token
});


$UserModelCopyWith<$Res>? get data;

}
/// @nodoc
class _$AuthStatusCopyWithImpl<$Res>
    implements $AuthStatusCopyWith<$Res> {
  _$AuthStatusCopyWithImpl(this._self, this._then);

  final AuthStatus _self;
  final $Res Function(AuthStatus) _then;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? data = freezed,Object? token = freezed,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AuthMode,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserModel?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthStatus].
extension AuthStatusPatterns on AuthStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthStatus value)  $default,){
final _that = this;
switch (_that) {
case _AuthStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthStatus value)?  $default,){
final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthMode state,  UserModel? data,  String? token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
return $default(_that.state,_that.data,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthMode state,  UserModel? data,  String? token)  $default,) {final _that = this;
switch (_that) {
case _AuthStatus():
return $default(_that.state,_that.data,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthMode state,  UserModel? data,  String? token)?  $default,) {final _that = this;
switch (_that) {
case _AuthStatus() when $default != null:
return $default(_that.state,_that.data,_that.token);case _:
  return null;

}
}

}

/// @nodoc


class _AuthStatus implements AuthStatus {
  const _AuthStatus({required this.state, this.data, this.token});
  

@override final  AuthMode state;
@override final  UserModel? data;
@override final  String? token;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStatusCopyWith<_AuthStatus> get copyWith => __$AuthStatusCopyWithImpl<_AuthStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthStatus&&(identical(other.state, state) || other.state == state)&&(identical(other.data, data) || other.data == data)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,state,data,token);

@override
String toString() {
  return 'AuthStatus(state: $state, data: $data, token: $token)';
}


}

/// @nodoc
abstract mixin class _$AuthStatusCopyWith<$Res> implements $AuthStatusCopyWith<$Res> {
  factory _$AuthStatusCopyWith(_AuthStatus value, $Res Function(_AuthStatus) _then) = __$AuthStatusCopyWithImpl;
@override @useResult
$Res call({
 AuthMode state, UserModel? data, String? token
});


@override $UserModelCopyWith<$Res>? get data;

}
/// @nodoc
class __$AuthStatusCopyWithImpl<$Res>
    implements _$AuthStatusCopyWith<$Res> {
  __$AuthStatusCopyWithImpl(this._self, this._then);

  final _AuthStatus _self;
  final $Res Function(_AuthStatus) _then;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? data = freezed,Object? token = freezed,}) {
  return _then(_AuthStatus(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AuthMode,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserModel?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
