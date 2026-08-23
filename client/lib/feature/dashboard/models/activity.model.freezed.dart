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
mixin _$HeartRateSummary {

 double? get averageBpm; int? get minBpm; int? get maxBpm; double? get restingBpm;
/// Create a copy of HeartRateSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeartRateSummaryCopyWith<HeartRateSummary> get copyWith => _$HeartRateSummaryCopyWithImpl<HeartRateSummary>(this as HeartRateSummary, _$identity);

  /// Serializes this HeartRateSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeartRateSummary&&(identical(other.averageBpm, averageBpm) || other.averageBpm == averageBpm)&&(identical(other.minBpm, minBpm) || other.minBpm == minBpm)&&(identical(other.maxBpm, maxBpm) || other.maxBpm == maxBpm)&&(identical(other.restingBpm, restingBpm) || other.restingBpm == restingBpm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageBpm,minBpm,maxBpm,restingBpm);

@override
String toString() {
  return 'HeartRateSummary(averageBpm: $averageBpm, minBpm: $minBpm, maxBpm: $maxBpm, restingBpm: $restingBpm)';
}


}

/// @nodoc
abstract mixin class $HeartRateSummaryCopyWith<$Res>  {
  factory $HeartRateSummaryCopyWith(HeartRateSummary value, $Res Function(HeartRateSummary) _then) = _$HeartRateSummaryCopyWithImpl;
@useResult
$Res call({
 double? averageBpm, int? minBpm, int? maxBpm, double? restingBpm
});




}
/// @nodoc
class _$HeartRateSummaryCopyWithImpl<$Res>
    implements $HeartRateSummaryCopyWith<$Res> {
  _$HeartRateSummaryCopyWithImpl(this._self, this._then);

  final HeartRateSummary _self;
  final $Res Function(HeartRateSummary) _then;

/// Create a copy of HeartRateSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? averageBpm = freezed,Object? minBpm = freezed,Object? maxBpm = freezed,Object? restingBpm = freezed,}) {
  return _then(_self.copyWith(
averageBpm: freezed == averageBpm ? _self.averageBpm : averageBpm // ignore: cast_nullable_to_non_nullable
as double?,minBpm: freezed == minBpm ? _self.minBpm : minBpm // ignore: cast_nullable_to_non_nullable
as int?,maxBpm: freezed == maxBpm ? _self.maxBpm : maxBpm // ignore: cast_nullable_to_non_nullable
as int?,restingBpm: freezed == restingBpm ? _self.restingBpm : restingBpm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [HeartRateSummary].
extension HeartRateSummaryPatterns on HeartRateSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeartRateSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeartRateSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeartRateSummary value)  $default,){
final _that = this;
switch (_that) {
case _HeartRateSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeartRateSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HeartRateSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? averageBpm,  int? minBpm,  int? maxBpm,  double? restingBpm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeartRateSummary() when $default != null:
return $default(_that.averageBpm,_that.minBpm,_that.maxBpm,_that.restingBpm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? averageBpm,  int? minBpm,  int? maxBpm,  double? restingBpm)  $default,) {final _that = this;
switch (_that) {
case _HeartRateSummary():
return $default(_that.averageBpm,_that.minBpm,_that.maxBpm,_that.restingBpm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? averageBpm,  int? minBpm,  int? maxBpm,  double? restingBpm)?  $default,) {final _that = this;
switch (_that) {
case _HeartRateSummary() when $default != null:
return $default(_that.averageBpm,_that.minBpm,_that.maxBpm,_that.restingBpm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeartRateSummary implements HeartRateSummary {
  const _HeartRateSummary({this.averageBpm, this.minBpm, this.maxBpm, this.restingBpm});
  factory _HeartRateSummary.fromJson(Map<String, dynamic> json) => _$HeartRateSummaryFromJson(json);

@override final  double? averageBpm;
@override final  int? minBpm;
@override final  int? maxBpm;
@override final  double? restingBpm;

/// Create a copy of HeartRateSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeartRateSummaryCopyWith<_HeartRateSummary> get copyWith => __$HeartRateSummaryCopyWithImpl<_HeartRateSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeartRateSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeartRateSummary&&(identical(other.averageBpm, averageBpm) || other.averageBpm == averageBpm)&&(identical(other.minBpm, minBpm) || other.minBpm == minBpm)&&(identical(other.maxBpm, maxBpm) || other.maxBpm == maxBpm)&&(identical(other.restingBpm, restingBpm) || other.restingBpm == restingBpm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageBpm,minBpm,maxBpm,restingBpm);

@override
String toString() {
  return 'HeartRateSummary(averageBpm: $averageBpm, minBpm: $minBpm, maxBpm: $maxBpm, restingBpm: $restingBpm)';
}


}

/// @nodoc
abstract mixin class _$HeartRateSummaryCopyWith<$Res> implements $HeartRateSummaryCopyWith<$Res> {
  factory _$HeartRateSummaryCopyWith(_HeartRateSummary value, $Res Function(_HeartRateSummary) _then) = __$HeartRateSummaryCopyWithImpl;
@override @useResult
$Res call({
 double? averageBpm, int? minBpm, int? maxBpm, double? restingBpm
});




}
/// @nodoc
class __$HeartRateSummaryCopyWithImpl<$Res>
    implements _$HeartRateSummaryCopyWith<$Res> {
  __$HeartRateSummaryCopyWithImpl(this._self, this._then);

  final _HeartRateSummary _self;
  final $Res Function(_HeartRateSummary) _then;

/// Create a copy of HeartRateSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? averageBpm = freezed,Object? minBpm = freezed,Object? maxBpm = freezed,Object? restingBpm = freezed,}) {
  return _then(_HeartRateSummary(
averageBpm: freezed == averageBpm ? _self.averageBpm : averageBpm // ignore: cast_nullable_to_non_nullable
as double?,minBpm: freezed == minBpm ? _self.minBpm : minBpm // ignore: cast_nullable_to_non_nullable
as int?,maxBpm: freezed == maxBpm ? _self.maxBpm : maxBpm // ignore: cast_nullable_to_non_nullable
as int?,restingBpm: freezed == restingBpm ? _self.restingBpm : restingBpm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$SleepSummary {

 int get totalMinutes; int get sessionCount;
/// Create a copy of SleepSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepSummaryCopyWith<SleepSummary> get copyWith => _$SleepSummaryCopyWithImpl<SleepSummary>(this as SleepSummary, _$identity);

  /// Serializes this SleepSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepSummary&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMinutes,sessionCount);

@override
String toString() {
  return 'SleepSummary(totalMinutes: $totalMinutes, sessionCount: $sessionCount)';
}


}

/// @nodoc
abstract mixin class $SleepSummaryCopyWith<$Res>  {
  factory $SleepSummaryCopyWith(SleepSummary value, $Res Function(SleepSummary) _then) = _$SleepSummaryCopyWithImpl;
@useResult
$Res call({
 int totalMinutes, int sessionCount
});




}
/// @nodoc
class _$SleepSummaryCopyWithImpl<$Res>
    implements $SleepSummaryCopyWith<$Res> {
  _$SleepSummaryCopyWithImpl(this._self, this._then);

  final SleepSummary _self;
  final $Res Function(SleepSummary) _then;

/// Create a copy of SleepSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalMinutes = null,Object? sessionCount = null,}) {
  return _then(_self.copyWith(
totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepSummary].
extension SleepSummaryPatterns on SleepSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepSummary value)  $default,){
final _that = this;
switch (_that) {
case _SleepSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SleepSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalMinutes,  int sessionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepSummary() when $default != null:
return $default(_that.totalMinutes,_that.sessionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalMinutes,  int sessionCount)  $default,) {final _that = this;
switch (_that) {
case _SleepSummary():
return $default(_that.totalMinutes,_that.sessionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalMinutes,  int sessionCount)?  $default,) {final _that = this;
switch (_that) {
case _SleepSummary() when $default != null:
return $default(_that.totalMinutes,_that.sessionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SleepSummary implements SleepSummary {
  const _SleepSummary({required this.totalMinutes, required this.sessionCount});
  factory _SleepSummary.fromJson(Map<String, dynamic> json) => _$SleepSummaryFromJson(json);

@override final  int totalMinutes;
@override final  int sessionCount;

/// Create a copy of SleepSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepSummaryCopyWith<_SleepSummary> get copyWith => __$SleepSummaryCopyWithImpl<_SleepSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SleepSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepSummary&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMinutes,sessionCount);

@override
String toString() {
  return 'SleepSummary(totalMinutes: $totalMinutes, sessionCount: $sessionCount)';
}


}

/// @nodoc
abstract mixin class _$SleepSummaryCopyWith<$Res> implements $SleepSummaryCopyWith<$Res> {
  factory _$SleepSummaryCopyWith(_SleepSummary value, $Res Function(_SleepSummary) _then) = __$SleepSummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalMinutes, int sessionCount
});




}
/// @nodoc
class __$SleepSummaryCopyWithImpl<$Res>
    implements _$SleepSummaryCopyWith<$Res> {
  __$SleepSummaryCopyWithImpl(this._self, this._then);

  final _SleepSummary _self;
  final $Res Function(_SleepSummary) _then;

/// Create a copy of SleepSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalMinutes = null,Object? sessionCount = null,}) {
  return _then(_SleepSummary(
totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkoutSummary {

 String get type; String? get title; DateTime get startTime; DateTime get endTime; int get durationMinutes;
/// Create a copy of WorkoutSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSummaryCopyWith<WorkoutSummary> get copyWith => _$WorkoutSummaryCopyWithImpl<WorkoutSummary>(this as WorkoutSummary, _$identity);

  /// Serializes this WorkoutSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSummary&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,startTime,endTime,durationMinutes);

@override
String toString() {
  return 'WorkoutSummary(type: $type, title: $title, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $WorkoutSummaryCopyWith<$Res>  {
  factory $WorkoutSummaryCopyWith(WorkoutSummary value, $Res Function(WorkoutSummary) _then) = _$WorkoutSummaryCopyWithImpl;
@useResult
$Res call({
 String type, String? title, DateTime startTime, DateTime endTime, int durationMinutes
});




}
/// @nodoc
class _$WorkoutSummaryCopyWithImpl<$Res>
    implements $WorkoutSummaryCopyWith<$Res> {
  _$WorkoutSummaryCopyWithImpl(this._self, this._then);

  final WorkoutSummary _self;
  final $Res Function(WorkoutSummary) _then;

/// Create a copy of WorkoutSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = freezed,Object? startTime = null,Object? endTime = null,Object? durationMinutes = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSummary].
extension WorkoutSummaryPatterns on WorkoutSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSummary value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? title,  DateTime startTime,  DateTime endTime,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSummary() when $default != null:
return $default(_that.type,_that.title,_that.startTime,_that.endTime,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? title,  DateTime startTime,  DateTime endTime,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSummary():
return $default(_that.type,_that.title,_that.startTime,_that.endTime,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? title,  DateTime startTime,  DateTime endTime,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSummary() when $default != null:
return $default(_that.type,_that.title,_that.startTime,_that.endTime,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutSummary implements WorkoutSummary {
  const _WorkoutSummary({required this.type, this.title, required this.startTime, required this.endTime, required this.durationMinutes});
  factory _WorkoutSummary.fromJson(Map<String, dynamic> json) => _$WorkoutSummaryFromJson(json);

@override final  String type;
@override final  String? title;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  int durationMinutes;

/// Create a copy of WorkoutSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSummaryCopyWith<_WorkoutSummary> get copyWith => __$WorkoutSummaryCopyWithImpl<_WorkoutSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutSummary&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,startTime,endTime,durationMinutes);

@override
String toString() {
  return 'WorkoutSummary(type: $type, title: $title, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSummaryCopyWith<$Res> implements $WorkoutSummaryCopyWith<$Res> {
  factory _$WorkoutSummaryCopyWith(_WorkoutSummary value, $Res Function(_WorkoutSummary) _then) = __$WorkoutSummaryCopyWithImpl;
@override @useResult
$Res call({
 String type, String? title, DateTime startTime, DateTime endTime, int durationMinutes
});




}
/// @nodoc
class __$WorkoutSummaryCopyWithImpl<$Res>
    implements _$WorkoutSummaryCopyWith<$Res> {
  __$WorkoutSummaryCopyWithImpl(this._self, this._then);

  final _WorkoutSummary _self;
  final $Res Function(_WorkoutSummary) _then;

/// Create a copy of WorkoutSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = freezed,Object? startTime = null,Object? endTime = null,Object? durationMinutes = null,}) {
  return _then(_WorkoutSummary(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BloodPressureSummary {

 double get systolicMmHg; double get diastolicMmHg; DateTime? get measuredAt;
/// Create a copy of BloodPressureSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BloodPressureSummaryCopyWith<BloodPressureSummary> get copyWith => _$BloodPressureSummaryCopyWithImpl<BloodPressureSummary>(this as BloodPressureSummary, _$identity);

  /// Serializes this BloodPressureSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BloodPressureSummary&&(identical(other.systolicMmHg, systolicMmHg) || other.systolicMmHg == systolicMmHg)&&(identical(other.diastolicMmHg, diastolicMmHg) || other.diastolicMmHg == diastolicMmHg)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systolicMmHg,diastolicMmHg,measuredAt);

@override
String toString() {
  return 'BloodPressureSummary(systolicMmHg: $systolicMmHg, diastolicMmHg: $diastolicMmHg, measuredAt: $measuredAt)';
}


}

/// @nodoc
abstract mixin class $BloodPressureSummaryCopyWith<$Res>  {
  factory $BloodPressureSummaryCopyWith(BloodPressureSummary value, $Res Function(BloodPressureSummary) _then) = _$BloodPressureSummaryCopyWithImpl;
@useResult
$Res call({
 double systolicMmHg, double diastolicMmHg, DateTime? measuredAt
});




}
/// @nodoc
class _$BloodPressureSummaryCopyWithImpl<$Res>
    implements $BloodPressureSummaryCopyWith<$Res> {
  _$BloodPressureSummaryCopyWithImpl(this._self, this._then);

  final BloodPressureSummary _self;
  final $Res Function(BloodPressureSummary) _then;

/// Create a copy of BloodPressureSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? systolicMmHg = null,Object? diastolicMmHg = null,Object? measuredAt = freezed,}) {
  return _then(_self.copyWith(
systolicMmHg: null == systolicMmHg ? _self.systolicMmHg : systolicMmHg // ignore: cast_nullable_to_non_nullable
as double,diastolicMmHg: null == diastolicMmHg ? _self.diastolicMmHg : diastolicMmHg // ignore: cast_nullable_to_non_nullable
as double,measuredAt: freezed == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BloodPressureSummary].
extension BloodPressureSummaryPatterns on BloodPressureSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BloodPressureSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BloodPressureSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BloodPressureSummary value)  $default,){
final _that = this;
switch (_that) {
case _BloodPressureSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BloodPressureSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BloodPressureSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double systolicMmHg,  double diastolicMmHg,  DateTime? measuredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BloodPressureSummary() when $default != null:
return $default(_that.systolicMmHg,_that.diastolicMmHg,_that.measuredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double systolicMmHg,  double diastolicMmHg,  DateTime? measuredAt)  $default,) {final _that = this;
switch (_that) {
case _BloodPressureSummary():
return $default(_that.systolicMmHg,_that.diastolicMmHg,_that.measuredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double systolicMmHg,  double diastolicMmHg,  DateTime? measuredAt)?  $default,) {final _that = this;
switch (_that) {
case _BloodPressureSummary() when $default != null:
return $default(_that.systolicMmHg,_that.diastolicMmHg,_that.measuredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BloodPressureSummary implements BloodPressureSummary {
  const _BloodPressureSummary({required this.systolicMmHg, required this.diastolicMmHg, this.measuredAt});
  factory _BloodPressureSummary.fromJson(Map<String, dynamic> json) => _$BloodPressureSummaryFromJson(json);

@override final  double systolicMmHg;
@override final  double diastolicMmHg;
@override final  DateTime? measuredAt;

/// Create a copy of BloodPressureSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BloodPressureSummaryCopyWith<_BloodPressureSummary> get copyWith => __$BloodPressureSummaryCopyWithImpl<_BloodPressureSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BloodPressureSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BloodPressureSummary&&(identical(other.systolicMmHg, systolicMmHg) || other.systolicMmHg == systolicMmHg)&&(identical(other.diastolicMmHg, diastolicMmHg) || other.diastolicMmHg == diastolicMmHg)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systolicMmHg,diastolicMmHg,measuredAt);

@override
String toString() {
  return 'BloodPressureSummary(systolicMmHg: $systolicMmHg, diastolicMmHg: $diastolicMmHg, measuredAt: $measuredAt)';
}


}

/// @nodoc
abstract mixin class _$BloodPressureSummaryCopyWith<$Res> implements $BloodPressureSummaryCopyWith<$Res> {
  factory _$BloodPressureSummaryCopyWith(_BloodPressureSummary value, $Res Function(_BloodPressureSummary) _then) = __$BloodPressureSummaryCopyWithImpl;
@override @useResult
$Res call({
 double systolicMmHg, double diastolicMmHg, DateTime? measuredAt
});




}
/// @nodoc
class __$BloodPressureSummaryCopyWithImpl<$Res>
    implements _$BloodPressureSummaryCopyWith<$Res> {
  __$BloodPressureSummaryCopyWithImpl(this._self, this._then);

  final _BloodPressureSummary _self;
  final $Res Function(_BloodPressureSummary) _then;

/// Create a copy of BloodPressureSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? systolicMmHg = null,Object? diastolicMmHg = null,Object? measuredAt = freezed,}) {
  return _then(_BloodPressureSummary(
systolicMmHg: null == systolicMmHg ? _self.systolicMmHg : systolicMmHg // ignore: cast_nullable_to_non_nullable
as double,diastolicMmHg: null == diastolicMmHg ? _self.diastolicMmHg : diastolicMmHg // ignore: cast_nullable_to_non_nullable
as double,measuredAt: freezed == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ActivityModel {

 DateTime get date; int? get steps; double? get distanceMeters; double? get activeCalories; double? get totalCalories; HeartRateSummary? get heartRate; SleepSummary? get sleep; List<WorkoutSummary> get workouts; double? get weightKilograms; double? get heightMeters; BloodPressureSummary? get bloodPressure; double? get bloodGlucoseMmolPerLiter; double? get oxygenSaturationPercent;
/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<ActivityModel> get copyWith => _$ActivityModelCopyWithImpl<ActivityModel>(this as ActivityModel, _$identity);

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityModel&&(identical(other.date, date) || other.date == date)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.activeCalories, activeCalories) || other.activeCalories == activeCalories)&&(identical(other.totalCalories, totalCalories) || other.totalCalories == totalCalories)&&(identical(other.heartRate, heartRate) || other.heartRate == heartRate)&&(identical(other.sleep, sleep) || other.sleep == sleep)&&const DeepCollectionEquality().equals(other.workouts, workouts)&&(identical(other.weightKilograms, weightKilograms) || other.weightKilograms == weightKilograms)&&(identical(other.heightMeters, heightMeters) || other.heightMeters == heightMeters)&&(identical(other.bloodPressure, bloodPressure) || other.bloodPressure == bloodPressure)&&(identical(other.bloodGlucoseMmolPerLiter, bloodGlucoseMmolPerLiter) || other.bloodGlucoseMmolPerLiter == bloodGlucoseMmolPerLiter)&&(identical(other.oxygenSaturationPercent, oxygenSaturationPercent) || other.oxygenSaturationPercent == oxygenSaturationPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,steps,distanceMeters,activeCalories,totalCalories,heartRate,sleep,const DeepCollectionEquality().hash(workouts),weightKilograms,heightMeters,bloodPressure,bloodGlucoseMmolPerLiter,oxygenSaturationPercent);

@override
String toString() {
  return 'ActivityModel(date: $date, steps: $steps, distanceMeters: $distanceMeters, activeCalories: $activeCalories, totalCalories: $totalCalories, heartRate: $heartRate, sleep: $sleep, workouts: $workouts, weightKilograms: $weightKilograms, heightMeters: $heightMeters, bloodPressure: $bloodPressure, bloodGlucoseMmolPerLiter: $bloodGlucoseMmolPerLiter, oxygenSaturationPercent: $oxygenSaturationPercent)';
}


}

/// @nodoc
abstract mixin class $ActivityModelCopyWith<$Res>  {
  factory $ActivityModelCopyWith(ActivityModel value, $Res Function(ActivityModel) _then) = _$ActivityModelCopyWithImpl;
@useResult
$Res call({
 DateTime date, int? steps, double? distanceMeters, double? activeCalories, double? totalCalories, HeartRateSummary? heartRate, SleepSummary? sleep, List<WorkoutSummary> workouts, double? weightKilograms, double? heightMeters, BloodPressureSummary? bloodPressure, double? bloodGlucoseMmolPerLiter, double? oxygenSaturationPercent
});


$HeartRateSummaryCopyWith<$Res>? get heartRate;$SleepSummaryCopyWith<$Res>? get sleep;$BloodPressureSummaryCopyWith<$Res>? get bloodPressure;

}
/// @nodoc
class _$ActivityModelCopyWithImpl<$Res>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._self, this._then);

  final ActivityModel _self;
  final $Res Function(ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? steps = freezed,Object? distanceMeters = freezed,Object? activeCalories = freezed,Object? totalCalories = freezed,Object? heartRate = freezed,Object? sleep = freezed,Object? workouts = null,Object? weightKilograms = freezed,Object? heightMeters = freezed,Object? bloodPressure = freezed,Object? bloodGlucoseMmolPerLiter = freezed,Object? oxygenSaturationPercent = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,activeCalories: freezed == activeCalories ? _self.activeCalories : activeCalories // ignore: cast_nullable_to_non_nullable
as double?,totalCalories: freezed == totalCalories ? _self.totalCalories : totalCalories // ignore: cast_nullable_to_non_nullable
as double?,heartRate: freezed == heartRate ? _self.heartRate : heartRate // ignore: cast_nullable_to_non_nullable
as HeartRateSummary?,sleep: freezed == sleep ? _self.sleep : sleep // ignore: cast_nullable_to_non_nullable
as SleepSummary?,workouts: null == workouts ? _self.workouts : workouts // ignore: cast_nullable_to_non_nullable
as List<WorkoutSummary>,weightKilograms: freezed == weightKilograms ? _self.weightKilograms : weightKilograms // ignore: cast_nullable_to_non_nullable
as double?,heightMeters: freezed == heightMeters ? _self.heightMeters : heightMeters // ignore: cast_nullable_to_non_nullable
as double?,bloodPressure: freezed == bloodPressure ? _self.bloodPressure : bloodPressure // ignore: cast_nullable_to_non_nullable
as BloodPressureSummary?,bloodGlucoseMmolPerLiter: freezed == bloodGlucoseMmolPerLiter ? _self.bloodGlucoseMmolPerLiter : bloodGlucoseMmolPerLiter // ignore: cast_nullable_to_non_nullable
as double?,oxygenSaturationPercent: freezed == oxygenSaturationPercent ? _self.oxygenSaturationPercent : oxygenSaturationPercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HeartRateSummaryCopyWith<$Res>? get heartRate {
    if (_self.heartRate == null) {
    return null;
  }

  return $HeartRateSummaryCopyWith<$Res>(_self.heartRate!, (value) {
    return _then(_self.copyWith(heartRate: value));
  });
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SleepSummaryCopyWith<$Res>? get sleep {
    if (_self.sleep == null) {
    return null;
  }

  return $SleepSummaryCopyWith<$Res>(_self.sleep!, (value) {
    return _then(_self.copyWith(sleep: value));
  });
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BloodPressureSummaryCopyWith<$Res>? get bloodPressure {
    if (_self.bloodPressure == null) {
    return null;
  }

  return $BloodPressureSummaryCopyWith<$Res>(_self.bloodPressure!, (value) {
    return _then(_self.copyWith(bloodPressure: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int? steps,  double? distanceMeters,  double? activeCalories,  double? totalCalories,  HeartRateSummary? heartRate,  SleepSummary? sleep,  List<WorkoutSummary> workouts,  double? weightKilograms,  double? heightMeters,  BloodPressureSummary? bloodPressure,  double? bloodGlucoseMmolPerLiter,  double? oxygenSaturationPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.date,_that.steps,_that.distanceMeters,_that.activeCalories,_that.totalCalories,_that.heartRate,_that.sleep,_that.workouts,_that.weightKilograms,_that.heightMeters,_that.bloodPressure,_that.bloodGlucoseMmolPerLiter,_that.oxygenSaturationPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int? steps,  double? distanceMeters,  double? activeCalories,  double? totalCalories,  HeartRateSummary? heartRate,  SleepSummary? sleep,  List<WorkoutSummary> workouts,  double? weightKilograms,  double? heightMeters,  BloodPressureSummary? bloodPressure,  double? bloodGlucoseMmolPerLiter,  double? oxygenSaturationPercent)  $default,) {final _that = this;
switch (_that) {
case _ActivityModel():
return $default(_that.date,_that.steps,_that.distanceMeters,_that.activeCalories,_that.totalCalories,_that.heartRate,_that.sleep,_that.workouts,_that.weightKilograms,_that.heightMeters,_that.bloodPressure,_that.bloodGlucoseMmolPerLiter,_that.oxygenSaturationPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int? steps,  double? distanceMeters,  double? activeCalories,  double? totalCalories,  HeartRateSummary? heartRate,  SleepSummary? sleep,  List<WorkoutSummary> workouts,  double? weightKilograms,  double? heightMeters,  BloodPressureSummary? bloodPressure,  double? bloodGlucoseMmolPerLiter,  double? oxygenSaturationPercent)?  $default,) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.date,_that.steps,_that.distanceMeters,_that.activeCalories,_that.totalCalories,_that.heartRate,_that.sleep,_that.workouts,_that.weightKilograms,_that.heightMeters,_that.bloodPressure,_that.bloodGlucoseMmolPerLiter,_that.oxygenSaturationPercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityModel extends ActivityModel {
  const _ActivityModel({required this.date, this.steps, this.distanceMeters, this.activeCalories, this.totalCalories, this.heartRate, this.sleep, final  List<WorkoutSummary> workouts = const <WorkoutSummary>[], this.weightKilograms, this.heightMeters, this.bloodPressure, this.bloodGlucoseMmolPerLiter, this.oxygenSaturationPercent}): _workouts = workouts,super._();
  factory _ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

@override final  DateTime date;
@override final  int? steps;
@override final  double? distanceMeters;
@override final  double? activeCalories;
@override final  double? totalCalories;
@override final  HeartRateSummary? heartRate;
@override final  SleepSummary? sleep;
 final  List<WorkoutSummary> _workouts;
@override@JsonKey() List<WorkoutSummary> get workouts {
  if (_workouts is EqualUnmodifiableListView) return _workouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workouts);
}

@override final  double? weightKilograms;
@override final  double? heightMeters;
@override final  BloodPressureSummary? bloodPressure;
@override final  double? bloodGlucoseMmolPerLiter;
@override final  double? oxygenSaturationPercent;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityModel&&(identical(other.date, date) || other.date == date)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.activeCalories, activeCalories) || other.activeCalories == activeCalories)&&(identical(other.totalCalories, totalCalories) || other.totalCalories == totalCalories)&&(identical(other.heartRate, heartRate) || other.heartRate == heartRate)&&(identical(other.sleep, sleep) || other.sleep == sleep)&&const DeepCollectionEquality().equals(other._workouts, _workouts)&&(identical(other.weightKilograms, weightKilograms) || other.weightKilograms == weightKilograms)&&(identical(other.heightMeters, heightMeters) || other.heightMeters == heightMeters)&&(identical(other.bloodPressure, bloodPressure) || other.bloodPressure == bloodPressure)&&(identical(other.bloodGlucoseMmolPerLiter, bloodGlucoseMmolPerLiter) || other.bloodGlucoseMmolPerLiter == bloodGlucoseMmolPerLiter)&&(identical(other.oxygenSaturationPercent, oxygenSaturationPercent) || other.oxygenSaturationPercent == oxygenSaturationPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,steps,distanceMeters,activeCalories,totalCalories,heartRate,sleep,const DeepCollectionEquality().hash(_workouts),weightKilograms,heightMeters,bloodPressure,bloodGlucoseMmolPerLiter,oxygenSaturationPercent);

@override
String toString() {
  return 'ActivityModel(date: $date, steps: $steps, distanceMeters: $distanceMeters, activeCalories: $activeCalories, totalCalories: $totalCalories, heartRate: $heartRate, sleep: $sleep, workouts: $workouts, weightKilograms: $weightKilograms, heightMeters: $heightMeters, bloodPressure: $bloodPressure, bloodGlucoseMmolPerLiter: $bloodGlucoseMmolPerLiter, oxygenSaturationPercent: $oxygenSaturationPercent)';
}


}

/// @nodoc
abstract mixin class _$ActivityModelCopyWith<$Res> implements $ActivityModelCopyWith<$Res> {
  factory _$ActivityModelCopyWith(_ActivityModel value, $Res Function(_ActivityModel) _then) = __$ActivityModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int? steps, double? distanceMeters, double? activeCalories, double? totalCalories, HeartRateSummary? heartRate, SleepSummary? sleep, List<WorkoutSummary> workouts, double? weightKilograms, double? heightMeters, BloodPressureSummary? bloodPressure, double? bloodGlucoseMmolPerLiter, double? oxygenSaturationPercent
});


@override $HeartRateSummaryCopyWith<$Res>? get heartRate;@override $SleepSummaryCopyWith<$Res>? get sleep;@override $BloodPressureSummaryCopyWith<$Res>? get bloodPressure;

}
/// @nodoc
class __$ActivityModelCopyWithImpl<$Res>
    implements _$ActivityModelCopyWith<$Res> {
  __$ActivityModelCopyWithImpl(this._self, this._then);

  final _ActivityModel _self;
  final $Res Function(_ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? steps = freezed,Object? distanceMeters = freezed,Object? activeCalories = freezed,Object? totalCalories = freezed,Object? heartRate = freezed,Object? sleep = freezed,Object? workouts = null,Object? weightKilograms = freezed,Object? heightMeters = freezed,Object? bloodPressure = freezed,Object? bloodGlucoseMmolPerLiter = freezed,Object? oxygenSaturationPercent = freezed,}) {
  return _then(_ActivityModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,activeCalories: freezed == activeCalories ? _self.activeCalories : activeCalories // ignore: cast_nullable_to_non_nullable
as double?,totalCalories: freezed == totalCalories ? _self.totalCalories : totalCalories // ignore: cast_nullable_to_non_nullable
as double?,heartRate: freezed == heartRate ? _self.heartRate : heartRate // ignore: cast_nullable_to_non_nullable
as HeartRateSummary?,sleep: freezed == sleep ? _self.sleep : sleep // ignore: cast_nullable_to_non_nullable
as SleepSummary?,workouts: null == workouts ? _self._workouts : workouts // ignore: cast_nullable_to_non_nullable
as List<WorkoutSummary>,weightKilograms: freezed == weightKilograms ? _self.weightKilograms : weightKilograms // ignore: cast_nullable_to_non_nullable
as double?,heightMeters: freezed == heightMeters ? _self.heightMeters : heightMeters // ignore: cast_nullable_to_non_nullable
as double?,bloodPressure: freezed == bloodPressure ? _self.bloodPressure : bloodPressure // ignore: cast_nullable_to_non_nullable
as BloodPressureSummary?,bloodGlucoseMmolPerLiter: freezed == bloodGlucoseMmolPerLiter ? _self.bloodGlucoseMmolPerLiter : bloodGlucoseMmolPerLiter // ignore: cast_nullable_to_non_nullable
as double?,oxygenSaturationPercent: freezed == oxygenSaturationPercent ? _self.oxygenSaturationPercent : oxygenSaturationPercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HeartRateSummaryCopyWith<$Res>? get heartRate {
    if (_self.heartRate == null) {
    return null;
  }

  return $HeartRateSummaryCopyWith<$Res>(_self.heartRate!, (value) {
    return _then(_self.copyWith(heartRate: value));
  });
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SleepSummaryCopyWith<$Res>? get sleep {
    if (_self.sleep == null) {
    return null;
  }

  return $SleepSummaryCopyWith<$Res>(_self.sleep!, (value) {
    return _then(_self.copyWith(sleep: value));
  });
}/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BloodPressureSummaryCopyWith<$Res>? get bloodPressure {
    if (_self.bloodPressure == null) {
    return null;
  }

  return $BloodPressureSummaryCopyWith<$Res>(_self.bloodPressure!, (value) {
    return _then(_self.copyWith(bloodPressure: value));
  });
}
}


/// @nodoc
mixin _$HealthDataResult {

 HealthAccessStatus get status; ActivityModel? get activity; List<String> get deniedMetrics;
/// Create a copy of HealthDataResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthDataResultCopyWith<HealthDataResult> get copyWith => _$HealthDataResultCopyWithImpl<HealthDataResult>(this as HealthDataResult, _$identity);

  /// Serializes this HealthDataResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthDataResult&&(identical(other.status, status) || other.status == status)&&(identical(other.activity, activity) || other.activity == activity)&&const DeepCollectionEquality().equals(other.deniedMetrics, deniedMetrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,activity,const DeepCollectionEquality().hash(deniedMetrics));

@override
String toString() {
  return 'HealthDataResult(status: $status, activity: $activity, deniedMetrics: $deniedMetrics)';
}


}

/// @nodoc
abstract mixin class $HealthDataResultCopyWith<$Res>  {
  factory $HealthDataResultCopyWith(HealthDataResult value, $Res Function(HealthDataResult) _then) = _$HealthDataResultCopyWithImpl;
@useResult
$Res call({
 HealthAccessStatus status, ActivityModel? activity, List<String> deniedMetrics
});


$ActivityModelCopyWith<$Res>? get activity;

}
/// @nodoc
class _$HealthDataResultCopyWithImpl<$Res>
    implements $HealthDataResultCopyWith<$Res> {
  _$HealthDataResultCopyWithImpl(this._self, this._then);

  final HealthDataResult _self;
  final $Res Function(HealthDataResult) _then;

/// Create a copy of HealthDataResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? activity = freezed,Object? deniedMetrics = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthAccessStatus,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityModel?,deniedMetrics: null == deniedMetrics ? _self.deniedMetrics : deniedMetrics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of HealthDataResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivityModelCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthDataResult].
extension HealthDataResultPatterns on HealthDataResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthDataResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthDataResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthDataResult value)  $default,){
final _that = this;
switch (_that) {
case _HealthDataResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthDataResult value)?  $default,){
final _that = this;
switch (_that) {
case _HealthDataResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HealthAccessStatus status,  ActivityModel? activity,  List<String> deniedMetrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthDataResult() when $default != null:
return $default(_that.status,_that.activity,_that.deniedMetrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HealthAccessStatus status,  ActivityModel? activity,  List<String> deniedMetrics)  $default,) {final _that = this;
switch (_that) {
case _HealthDataResult():
return $default(_that.status,_that.activity,_that.deniedMetrics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HealthAccessStatus status,  ActivityModel? activity,  List<String> deniedMetrics)?  $default,) {final _that = this;
switch (_that) {
case _HealthDataResult() when $default != null:
return $default(_that.status,_that.activity,_that.deniedMetrics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthDataResult implements HealthDataResult {
  const _HealthDataResult({required this.status, this.activity = null, final  List<String> deniedMetrics = const <String>[]}): _deniedMetrics = deniedMetrics;
  factory _HealthDataResult.fromJson(Map<String, dynamic> json) => _$HealthDataResultFromJson(json);

@override final  HealthAccessStatus status;
@override@JsonKey() final  ActivityModel? activity;
 final  List<String> _deniedMetrics;
@override@JsonKey() List<String> get deniedMetrics {
  if (_deniedMetrics is EqualUnmodifiableListView) return _deniedMetrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deniedMetrics);
}


/// Create a copy of HealthDataResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthDataResultCopyWith<_HealthDataResult> get copyWith => __$HealthDataResultCopyWithImpl<_HealthDataResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthDataResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthDataResult&&(identical(other.status, status) || other.status == status)&&(identical(other.activity, activity) || other.activity == activity)&&const DeepCollectionEquality().equals(other._deniedMetrics, _deniedMetrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,activity,const DeepCollectionEquality().hash(_deniedMetrics));

@override
String toString() {
  return 'HealthDataResult(status: $status, activity: $activity, deniedMetrics: $deniedMetrics)';
}


}

/// @nodoc
abstract mixin class _$HealthDataResultCopyWith<$Res> implements $HealthDataResultCopyWith<$Res> {
  factory _$HealthDataResultCopyWith(_HealthDataResult value, $Res Function(_HealthDataResult) _then) = __$HealthDataResultCopyWithImpl;
@override @useResult
$Res call({
 HealthAccessStatus status, ActivityModel? activity, List<String> deniedMetrics
});


@override $ActivityModelCopyWith<$Res>? get activity;

}
/// @nodoc
class __$HealthDataResultCopyWithImpl<$Res>
    implements _$HealthDataResultCopyWith<$Res> {
  __$HealthDataResultCopyWithImpl(this._self, this._then);

  final _HealthDataResult _self;
  final $Res Function(_HealthDataResult) _then;

/// Create a copy of HealthDataResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? activity = freezed,Object? deniedMetrics = null,}) {
  return _then(_HealthDataResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthAccessStatus,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityModel?,deniedMetrics: null == deniedMetrics ? _self._deniedMetrics : deniedMetrics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of HealthDataResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<$Res>? get activity {
    if (_self.activity == null) {
    return null;
  }

  return $ActivityModelCopyWith<$Res>(_self.activity!, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

// dart format on
