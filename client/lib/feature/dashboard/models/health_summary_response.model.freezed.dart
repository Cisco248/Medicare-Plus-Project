// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_summary_response.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthSummaryResponse {

 String get summary; List<String> get recommendations; String? get disclaimer; DateTime? get generatedAt;
/// Create a copy of HealthSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthSummaryResponseCopyWith<HealthSummaryResponse> get copyWith => _$HealthSummaryResponseCopyWithImpl<HealthSummaryResponse>(this as HealthSummaryResponse, _$identity);

  /// Serializes this HealthSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthSummaryResponse&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.recommendations, recommendations)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(recommendations),disclaimer,generatedAt);

@override
String toString() {
  return 'HealthSummaryResponse(summary: $summary, recommendations: $recommendations, disclaimer: $disclaimer, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class $HealthSummaryResponseCopyWith<$Res>  {
  factory $HealthSummaryResponseCopyWith(HealthSummaryResponse value, $Res Function(HealthSummaryResponse) _then) = _$HealthSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String summary, List<String> recommendations, String? disclaimer, DateTime? generatedAt
});




}
/// @nodoc
class _$HealthSummaryResponseCopyWithImpl<$Res>
    implements $HealthSummaryResponseCopyWith<$Res> {
  _$HealthSummaryResponseCopyWithImpl(this._self, this._then);

  final HealthSummaryResponse _self;
  final $Res Function(HealthSummaryResponse) _then;

/// Create a copy of HealthSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? recommendations = null,Object? disclaimer = freezed,Object? generatedAt = freezed,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,disclaimer: freezed == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthSummaryResponse].
extension HealthSummaryResponsePatterns on HealthSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _HealthSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HealthSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<String> recommendations,  String? disclaimer,  DateTime? generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthSummaryResponse() when $default != null:
return $default(_that.summary,_that.recommendations,_that.disclaimer,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<String> recommendations,  String? disclaimer,  DateTime? generatedAt)  $default,) {final _that = this;
switch (_that) {
case _HealthSummaryResponse():
return $default(_that.summary,_that.recommendations,_that.disclaimer,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<String> recommendations,  String? disclaimer,  DateTime? generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HealthSummaryResponse() when $default != null:
return $default(_that.summary,_that.recommendations,_that.disclaimer,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthSummaryResponse implements HealthSummaryResponse {
  const _HealthSummaryResponse({required this.summary, final  List<String> recommendations = const <String>[], this.disclaimer, this.generatedAt}): _recommendations = recommendations;
  factory _HealthSummaryResponse.fromJson(Map<String, dynamic> json) => _$HealthSummaryResponseFromJson(json);

@override final  String summary;
 final  List<String> _recommendations;
@override@JsonKey() List<String> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}

@override final  String? disclaimer;
@override final  DateTime? generatedAt;

/// Create a copy of HealthSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthSummaryResponseCopyWith<_HealthSummaryResponse> get copyWith => __$HealthSummaryResponseCopyWithImpl<_HealthSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthSummaryResponse&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_recommendations),disclaimer,generatedAt);

@override
String toString() {
  return 'HealthSummaryResponse(summary: $summary, recommendations: $recommendations, disclaimer: $disclaimer, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$HealthSummaryResponseCopyWith<$Res> implements $HealthSummaryResponseCopyWith<$Res> {
  factory _$HealthSummaryResponseCopyWith(_HealthSummaryResponse value, $Res Function(_HealthSummaryResponse) _then) = __$HealthSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<String> recommendations, String? disclaimer, DateTime? generatedAt
});




}
/// @nodoc
class __$HealthSummaryResponseCopyWithImpl<$Res>
    implements _$HealthSummaryResponseCopyWith<$Res> {
  __$HealthSummaryResponseCopyWithImpl(this._self, this._then);

  final _HealthSummaryResponse _self;
  final $Res Function(_HealthSummaryResponse) _then;

/// Create a copy of HealthSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? recommendations = null,Object? disclaimer = freezed,Object? generatedAt = freezed,}) {
  return _then(_HealthSummaryResponse(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,disclaimer: freezed == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
