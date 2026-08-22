// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doc.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocState {

 DocPhase get phase; DocModel? get model; String? get prediction; String? get explanation; String? get errorMessage;
/// Create a copy of DocState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocStateCopyWith<DocState> get copyWith => _$DocStateCopyWithImpl<DocState>(this as DocState, _$identity);

  /// Serializes this DocState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.model, model) || other.model == model)&&(identical(other.prediction, prediction) || other.prediction == prediction)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,model,prediction,explanation,errorMessage);

@override
String toString() {
  return 'DocState(phase: $phase, model: $model, prediction: $prediction, explanation: $explanation, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $DocStateCopyWith<$Res>  {
  factory $DocStateCopyWith(DocState value, $Res Function(DocState) _then) = _$DocStateCopyWithImpl;
@useResult
$Res call({
 DocPhase phase, DocModel? model, String? prediction, String? explanation, String? errorMessage
});




}
/// @nodoc
class _$DocStateCopyWithImpl<$Res>
    implements $DocStateCopyWith<$Res> {
  _$DocStateCopyWithImpl(this._self, this._then);

  final DocState _self;
  final $Res Function(DocState) _then;

/// Create a copy of DocState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? model = freezed,Object? prediction = freezed,Object? explanation = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as DocPhase,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as DocModel?,prediction: freezed == prediction ? _self.prediction : prediction // ignore: cast_nullable_to_non_nullable
as String?,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DocState].
extension DocStatePatterns on DocState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocState value)  $default,){
final _that = this;
switch (_that) {
case _DocState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocState value)?  $default,){
final _that = this;
switch (_that) {
case _DocState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DocPhase phase,  DocModel? model,  String? prediction,  String? explanation,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocState() when $default != null:
return $default(_that.phase,_that.model,_that.prediction,_that.explanation,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DocPhase phase,  DocModel? model,  String? prediction,  String? explanation,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _DocState():
return $default(_that.phase,_that.model,_that.prediction,_that.explanation,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DocPhase phase,  DocModel? model,  String? prediction,  String? explanation,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DocState() when $default != null:
return $default(_that.phase,_that.model,_that.prediction,_that.explanation,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocState extends DocState {
  const _DocState({this.phase = DocPhase.idle, this.model = null, this.prediction = null, this.explanation = null, this.errorMessage = null}): super._();
  factory _DocState.fromJson(Map<String, dynamic> json) => _$DocStateFromJson(json);

@override@JsonKey() final  DocPhase phase;
@override@JsonKey() final  DocModel? model;
@override@JsonKey() final  String? prediction;
@override@JsonKey() final  String? explanation;
@override@JsonKey() final  String? errorMessage;

/// Create a copy of DocState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocStateCopyWith<_DocState> get copyWith => __$DocStateCopyWithImpl<_DocState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.model, model) || other.model == model)&&(identical(other.prediction, prediction) || other.prediction == prediction)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,model,prediction,explanation,errorMessage);

@override
String toString() {
  return 'DocState(phase: $phase, model: $model, prediction: $prediction, explanation: $explanation, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$DocStateCopyWith<$Res> implements $DocStateCopyWith<$Res> {
  factory _$DocStateCopyWith(_DocState value, $Res Function(_DocState) _then) = __$DocStateCopyWithImpl;
@override @useResult
$Res call({
 DocPhase phase, DocModel? model, String? prediction, String? explanation, String? errorMessage
});




}
/// @nodoc
class __$DocStateCopyWithImpl<$Res>
    implements _$DocStateCopyWith<$Res> {
  __$DocStateCopyWithImpl(this._self, this._then);

  final _DocState _self;
  final $Res Function(_DocState) _then;

/// Create a copy of DocState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? model = freezed,Object? prediction = freezed,Object? explanation = freezed,Object? errorMessage = freezed,}) {
  return _then(_DocState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as DocPhase,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as DocModel?,prediction: freezed == prediction ? _self.prediction : prediction // ignore: cast_nullable_to_non_nullable
as String?,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
