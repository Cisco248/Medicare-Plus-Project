// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityModel {

 int get steps; int get walking; int get running; int get climbing; int get sleeping;
/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<ActivityModel> get copyWith => _$ActivityModelCopyWithImpl<ActivityModel>(this as ActivityModel, _$identity);

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityModel&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.walking, walking) || other.walking == walking)&&(identical(other.running, running) || other.running == running)&&(identical(other.climbing, climbing) || other.climbing == climbing)&&(identical(other.sleeping, sleeping) || other.sleeping == sleeping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,steps,walking,running,climbing,sleeping);

@override
String toString() {
  return 'ActivityModel(steps: $steps, walking: $walking, running: $running, climbing: $climbing, sleeping: $sleeping)';
}


}

/// @nodoc
abstract mixin class $ActivityModelCopyWith<$Res>  {
  factory $ActivityModelCopyWith(ActivityModel value, $Res Function(ActivityModel) _then) = _$ActivityModelCopyWithImpl;
@useResult
$Res call({
 int steps, int walking, int running, int climbing, int sleeping
});




}
/// @nodoc
class _$ActivityModelCopyWithImpl<$Res>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._self, this._then);

  final ActivityModel _self;
  final $Res Function(ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? steps = null,Object? walking = null,Object? running = null,Object? climbing = null,Object? sleeping = null,}) {
  return _then(_self.copyWith(
steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,walking: null == walking ? _self.walking : walking // ignore: cast_nullable_to_non_nullable
as int,running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as int,climbing: null == climbing ? _self.climbing : climbing // ignore: cast_nullable_to_non_nullable
as int,sleeping: null == sleeping ? _self.sleeping : sleeping // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityModel].
extension ActivityModelPatterns on ActivityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int steps,  int walking,  int running,  int climbing,  int sleeping)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.steps,_that.walking,_that.running,_that.climbing,_that.sleeping);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int steps,  int walking,  int running,  int climbing,  int sleeping)  $default,) {final _that = this;
switch (_that) {
case _ActivityModel():
return $default(_that.steps,_that.walking,_that.running,_that.climbing,_that.sleeping);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int steps,  int walking,  int running,  int climbing,  int sleeping)?  $default,) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.steps,_that.walking,_that.running,_that.climbing,_that.sleeping);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityModel implements ActivityModel {
  const _ActivityModel({this.steps = 0, this.walking = 0, this.running = 0, this.climbing = 0, this.sleeping = 0});
  factory _ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

@override@JsonKey() final  int steps;
@override@JsonKey() final  int walking;
@override@JsonKey() final  int running;
@override@JsonKey() final  int climbing;
@override@JsonKey() final  int sleeping;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityModelCopyWith<_ActivityModel> get copyWith => __$ActivityModelCopyWithImpl<_ActivityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityModel&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.walking, walking) || other.walking == walking)&&(identical(other.running, running) || other.running == running)&&(identical(other.climbing, climbing) || other.climbing == climbing)&&(identical(other.sleeping, sleeping) || other.sleeping == sleeping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,steps,walking,running,climbing,sleeping);

@override
String toString() {
  return 'ActivityModel(steps: $steps, walking: $walking, running: $running, climbing: $climbing, sleeping: $sleeping)';
}


}

/// @nodoc
abstract mixin class _$ActivityModelCopyWith<$Res> implements $ActivityModelCopyWith<$Res> {
  factory _$ActivityModelCopyWith(_ActivityModel value, $Res Function(_ActivityModel) _then) = __$ActivityModelCopyWithImpl;
@override @useResult
$Res call({
 int steps, int walking, int running, int climbing, int sleeping
});




}
/// @nodoc
class __$ActivityModelCopyWithImpl<$Res>
    implements _$ActivityModelCopyWith<$Res> {
  __$ActivityModelCopyWithImpl(this._self, this._then);

  final _ActivityModel _self;
  final $Res Function(_ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? steps = null,Object? walking = null,Object? running = null,Object? climbing = null,Object? sleeping = null,}) {
  return _then(_ActivityModel(
steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,walking: null == walking ? _self.walking : walking // ignore: cast_nullable_to_non_nullable
as int,running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as int,climbing: null == climbing ? _self.climbing : climbing // ignore: cast_nullable_to_non_nullable
as int,sleeping: null == sleeping ? _self.sleeping : sleeping // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
