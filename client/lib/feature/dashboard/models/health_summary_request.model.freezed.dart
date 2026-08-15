// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_summary_request.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SummaryPeriod {

 DateTime get start; DateTime get end; String? get timezoneOffset;
/// Create a copy of SummaryPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SummaryPeriodCopyWith<SummaryPeriod> get copyWith => _$SummaryPeriodCopyWithImpl<SummaryPeriod>(this as SummaryPeriod, _$identity);

  /// Serializes this SummaryPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SummaryPeriod&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.timezoneOffset, timezoneOffset) || other.timezoneOffset == timezoneOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,timezoneOffset);

@override
String toString() {
  return 'SummaryPeriod(start: $start, end: $end, timezoneOffset: $timezoneOffset)';
}


}

/// @nodoc
abstract mixin class $SummaryPeriodCopyWith<$Res>  {
  factory $SummaryPeriodCopyWith(SummaryPeriod value, $Res Function(SummaryPeriod) _then) = _$SummaryPeriodCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end, String? timezoneOffset
});




}
/// @nodoc
class _$SummaryPeriodCopyWithImpl<$Res>
    implements $SummaryPeriodCopyWith<$Res> {
  _$SummaryPeriodCopyWithImpl(this._self, this._then);

  final SummaryPeriod _self;
  final $Res Function(SummaryPeriod) _then;

/// Create a copy of SummaryPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? timezoneOffset = freezed,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,timezoneOffset: freezed == timezoneOffset ? _self.timezoneOffset : timezoneOffset // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SummaryPeriod].
extension SummaryPeriodPatterns on SummaryPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SummaryPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SummaryPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SummaryPeriod value)  $default,){
final _that = this;
switch (_that) {
case _SummaryPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SummaryPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _SummaryPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  String? timezoneOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SummaryPeriod() when $default != null:
return $default(_that.start,_that.end,_that.timezoneOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  String? timezoneOffset)  $default,) {final _that = this;
switch (_that) {
case _SummaryPeriod():
return $default(_that.start,_that.end,_that.timezoneOffset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end,  String? timezoneOffset)?  $default,) {final _that = this;
switch (_that) {
case _SummaryPeriod() when $default != null:
return $default(_that.start,_that.end,_that.timezoneOffset);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SummaryPeriod implements SummaryPeriod {
  const _SummaryPeriod({required this.start, required this.end, this.timezoneOffset});
  factory _SummaryPeriod.fromJson(Map<String, dynamic> json) => _$SummaryPeriodFromJson(json);

@override final  DateTime start;
@override final  DateTime end;
@override final  String? timezoneOffset;

/// Create a copy of SummaryPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SummaryPeriodCopyWith<_SummaryPeriod> get copyWith => __$SummaryPeriodCopyWithImpl<_SummaryPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SummaryPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SummaryPeriod&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.timezoneOffset, timezoneOffset) || other.timezoneOffset == timezoneOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,timezoneOffset);

@override
String toString() {
  return 'SummaryPeriod(start: $start, end: $end, timezoneOffset: $timezoneOffset)';
}


}

/// @nodoc
abstract mixin class _$SummaryPeriodCopyWith<$Res> implements $SummaryPeriodCopyWith<$Res> {
  factory _$SummaryPeriodCopyWith(_SummaryPeriod value, $Res Function(_SummaryPeriod) _then) = __$SummaryPeriodCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end, String? timezoneOffset
});




}
/// @nodoc
class __$SummaryPeriodCopyWithImpl<$Res>
    implements _$SummaryPeriodCopyWith<$Res> {
  __$SummaryPeriodCopyWithImpl(this._self, this._then);

  final _SummaryPeriod _self;
  final $Res Function(_SummaryPeriod) _then;

/// Create a copy of SummaryPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? timezoneOffset = freezed,}) {
  return _then(_SummaryPeriod(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,timezoneOffset: freezed == timezoneOffset ? _self.timezoneOffset : timezoneOffset // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HealthSummaryRequest {

 String? get userId; SummaryPeriod get period; ActivityModel get activities;
/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthSummaryRequestCopyWith<HealthSummaryRequest> get copyWith => _$HealthSummaryRequestCopyWithImpl<HealthSummaryRequest>(this as HealthSummaryRequest, _$identity);

  /// Serializes this HealthSummaryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthSummaryRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.period, period) || other.period == period)&&(identical(other.activities, activities) || other.activities == activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,period,activities);

@override
String toString() {
  return 'HealthSummaryRequest(userId: $userId, period: $period, activities: $activities)';
}


}

/// @nodoc
abstract mixin class $HealthSummaryRequestCopyWith<$Res>  {
  factory $HealthSummaryRequestCopyWith(HealthSummaryRequest value, $Res Function(HealthSummaryRequest) _then) = _$HealthSummaryRequestCopyWithImpl;
@useResult
$Res call({
 String? userId, SummaryPeriod period, ActivityModel activities
});


$SummaryPeriodCopyWith<$Res> get period;$ActivityModelCopyWith<$Res> get activities;

}
/// @nodoc
class _$HealthSummaryRequestCopyWithImpl<$Res>
    implements $HealthSummaryRequestCopyWith<$Res> {
  _$HealthSummaryRequestCopyWithImpl(this._self, this._then);

  final HealthSummaryRequest _self;
  final $Res Function(HealthSummaryRequest) _then;

/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? period = null,Object? activities = null,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as SummaryPeriod,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as ActivityModel,
  ));
}
/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SummaryPeriodCopyWith<$Res> get period {
  
  return $SummaryPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<$Res> get activities {
  
  return $ActivityModelCopyWith<$Res>(_self.activities, (value) {
    return _then(_self.copyWith(activities: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthSummaryRequest].
extension HealthSummaryRequestPatterns on HealthSummaryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthSummaryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthSummaryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthSummaryRequest value)  $default,){
final _that = this;
switch (_that) {
case _HealthSummaryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthSummaryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _HealthSummaryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? userId,  SummaryPeriod period,  ActivityModel activities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthSummaryRequest() when $default != null:
return $default(_that.userId,_that.period,_that.activities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? userId,  SummaryPeriod period,  ActivityModel activities)  $default,) {final _that = this;
switch (_that) {
case _HealthSummaryRequest():
return $default(_that.userId,_that.period,_that.activities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? userId,  SummaryPeriod period,  ActivityModel activities)?  $default,) {final _that = this;
switch (_that) {
case _HealthSummaryRequest() when $default != null:
return $default(_that.userId,_that.period,_that.activities);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _HealthSummaryRequest implements HealthSummaryRequest {
  const _HealthSummaryRequest({this.userId, required this.period, required this.activities});
  factory _HealthSummaryRequest.fromJson(Map<String, dynamic> json) => _$HealthSummaryRequestFromJson(json);

@override final  String? userId;
@override final  SummaryPeriod period;
@override final  ActivityModel activities;

/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthSummaryRequestCopyWith<_HealthSummaryRequest> get copyWith => __$HealthSummaryRequestCopyWithImpl<_HealthSummaryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthSummaryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthSummaryRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.period, period) || other.period == period)&&(identical(other.activities, activities) || other.activities == activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,period,activities);

@override
String toString() {
  return 'HealthSummaryRequest(userId: $userId, period: $period, activities: $activities)';
}


}

/// @nodoc
abstract mixin class _$HealthSummaryRequestCopyWith<$Res> implements $HealthSummaryRequestCopyWith<$Res> {
  factory _$HealthSummaryRequestCopyWith(_HealthSummaryRequest value, $Res Function(_HealthSummaryRequest) _then) = __$HealthSummaryRequestCopyWithImpl;
@override @useResult
$Res call({
 String? userId, SummaryPeriod period, ActivityModel activities
});


@override $SummaryPeriodCopyWith<$Res> get period;@override $ActivityModelCopyWith<$Res> get activities;

}
/// @nodoc
class __$HealthSummaryRequestCopyWithImpl<$Res>
    implements _$HealthSummaryRequestCopyWith<$Res> {
  __$HealthSummaryRequestCopyWithImpl(this._self, this._then);

  final _HealthSummaryRequest _self;
  final $Res Function(_HealthSummaryRequest) _then;

/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? period = null,Object? activities = null,}) {
  return _then(_HealthSummaryRequest(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as SummaryPeriod,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as ActivityModel,
  ));
}

/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SummaryPeriodCopyWith<$Res> get period {
  
  return $SummaryPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of HealthSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<$Res> get activities {
  
  return $ActivityModelCopyWith<$Res>(_self.activities, (value) {
    return _then(_self.copyWith(activities: value));
  });
}
}

// dart format on
