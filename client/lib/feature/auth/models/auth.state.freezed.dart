// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FormStates {

 FormMode get state;
/// Create a copy of FormStates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormStatesCopyWith<FormStates> get copyWith => _$FormStatesCopyWithImpl<FormStates>(this as FormStates, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormStates&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'FormStates(state: $state)';
}


}

/// @nodoc
abstract mixin class $FormStatesCopyWith<$Res>  {
  factory $FormStatesCopyWith(FormStates value, $Res Function(FormStates) _then) = _$FormStatesCopyWithImpl;
@useResult
$Res call({
 FormMode state
});




}
/// @nodoc
class _$FormStatesCopyWithImpl<$Res>
    implements $FormStatesCopyWith<$Res> {
  _$FormStatesCopyWithImpl(this._self, this._then);

  final FormStates _self;
  final $Res Function(FormStates) _then;

/// Create a copy of FormStates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as FormMode,
  ));
}

}


/// Adds pattern-matching-related methods to [FormStates].
extension FormStatesPatterns on FormStates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormStates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormStates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormStates value)  $default,){
final _that = this;
switch (_that) {
case _FormStates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormStates value)?  $default,){
final _that = this;
switch (_that) {
case _FormStates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FormMode state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormStates() when $default != null:
return $default(_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FormMode state)  $default,) {final _that = this;
switch (_that) {
case _FormStates():
return $default(_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FormMode state)?  $default,) {final _that = this;
switch (_that) {
case _FormStates() when $default != null:
return $default(_that.state);case _:
  return null;

}
}

}

/// @nodoc


class _FormStates implements FormStates {
  const _FormStates({required this.state});
  

@override final  FormMode state;

/// Create a copy of FormStates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormStatesCopyWith<_FormStates> get copyWith => __$FormStatesCopyWithImpl<_FormStates>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormStates&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'FormStates(state: $state)';
}


}

/// @nodoc
abstract mixin class _$FormStatesCopyWith<$Res> implements $FormStatesCopyWith<$Res> {
  factory _$FormStatesCopyWith(_FormStates value, $Res Function(_FormStates) _then) = __$FormStatesCopyWithImpl;
@override @useResult
$Res call({
 FormMode state
});




}
/// @nodoc
class __$FormStatesCopyWithImpl<$Res>
    implements _$FormStatesCopyWith<$Res> {
  __$FormStatesCopyWithImpl(this._self, this._then);

  final _FormStates _self;
  final $Res Function(_FormStates) _then;

/// Create a copy of FormStates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(_FormStates(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as FormMode,
  ));
}


}

/// @nodoc
mixin _$AuthStates {

 AuthMode get state; AuthResponseModel? get data;
/// Create a copy of AuthStates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStatesCopyWith<AuthStates> get copyWith => _$AuthStatesCopyWithImpl<AuthStates>(this as AuthStates, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStates&&(identical(other.state, state) || other.state == state)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,state,data);

@override
String toString() {
  return 'AuthStates(state: $state, data: $data)';
}


}

/// @nodoc
abstract mixin class $AuthStatesCopyWith<$Res>  {
  factory $AuthStatesCopyWith(AuthStates value, $Res Function(AuthStates) _then) = _$AuthStatesCopyWithImpl;
@useResult
$Res call({
 AuthMode state, AuthResponseModel? data
});


$AuthResponseModelCopyWith<$Res>? get data;

}
/// @nodoc
class _$AuthStatesCopyWithImpl<$Res>
    implements $AuthStatesCopyWith<$Res> {
  _$AuthStatesCopyWithImpl(this._self, this._then);

  final AuthStates _self;
  final $Res Function(AuthStates) _then;

/// Create a copy of AuthStates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AuthMode,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthResponseModel?,
  ));
}
/// Create a copy of AuthStates
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthResponseModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AuthResponseModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthStates].
extension AuthStatesPatterns on AuthStates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthStates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthStates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthStates value)  $default,){
final _that = this;
switch (_that) {
case _AuthStates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthStates value)?  $default,){
final _that = this;
switch (_that) {
case _AuthStates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthMode state,  AuthResponseModel? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthStates() when $default != null:
return $default(_that.state,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthMode state,  AuthResponseModel? data)  $default,) {final _that = this;
switch (_that) {
case _AuthStates():
return $default(_that.state,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthMode state,  AuthResponseModel? data)?  $default,) {final _that = this;
switch (_that) {
case _AuthStates() when $default != null:
return $default(_that.state,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _AuthStates implements AuthStates {
  const _AuthStates({required this.state, this.data});
  

@override final  AuthMode state;
@override final  AuthResponseModel? data;

/// Create a copy of AuthStates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStatesCopyWith<_AuthStates> get copyWith => __$AuthStatesCopyWithImpl<_AuthStates>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthStates&&(identical(other.state, state) || other.state == state)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,state,data);

@override
String toString() {
  return 'AuthStates(state: $state, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AuthStatesCopyWith<$Res> implements $AuthStatesCopyWith<$Res> {
  factory _$AuthStatesCopyWith(_AuthStates value, $Res Function(_AuthStates) _then) = __$AuthStatesCopyWithImpl;
@override @useResult
$Res call({
 AuthMode state, AuthResponseModel? data
});


@override $AuthResponseModelCopyWith<$Res>? get data;

}
/// @nodoc
class __$AuthStatesCopyWithImpl<$Res>
    implements _$AuthStatesCopyWith<$Res> {
  __$AuthStatesCopyWithImpl(this._self, this._then);

  final _AuthStates _self;
  final $Res Function(_AuthStates) _then;

/// Create a copy of AuthStates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? data = freezed,}) {
  return _then(_AuthStates(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AuthMode,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthResponseModel?,
  ));
}

/// Create a copy of AuthStates
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthResponseModelCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AuthResponseModelCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
