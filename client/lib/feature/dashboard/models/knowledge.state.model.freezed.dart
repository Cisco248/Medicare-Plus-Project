// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledge.state.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KnowledgeState {

 KnowledgePhase get phase; DateTime get periodStart; DateTime get periodEnd; ActivityModel? get activity; HealthSummaryResponse? get summary;/// The activity snapshot the current [summary] was generated from,
/// used to avoid regenerating a summary for unchanged data.
 ActivityModel? get summarySource;/// User-friendly error description. Never a raw exception/stack trace.
 String? get errorMessage;/// Names of the metrics the user has not granted access to.
 List<String> get unavailableMetrics;
/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KnowledgeStateCopyWith<KnowledgeState> get copyWith => _$KnowledgeStateCopyWithImpl<KnowledgeState>(this as KnowledgeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnowledgeState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.summarySource, summarySource) || other.summarySource == summarySource)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.unavailableMetrics, unavailableMetrics));
}


@override
int get hashCode => Object.hash(runtimeType,phase,periodStart,periodEnd,activity,summary,summarySource,errorMessage,const DeepCollectionEquality().hash(unavailableMetrics));

@override
String toString() {
  return 'KnowledgeState(phase: $phase, periodStart: $periodStart, periodEnd: $periodEnd, activity: $activity, summary: $summary, summarySource: $summarySource, errorMessage: $errorMessage, unavailableMetrics: $unavailableMetrics)';
}


}

/// @nodoc
abstract mixin class $KnowledgeStateCopyWith<$Res>  {
  factory $KnowledgeStateCopyWith(KnowledgeState value, $Res Function(KnowledgeState) _then) = _$KnowledgeStateCopyWithImpl;
@useResult
$Res call({
 KnowledgePhase phase, DateTime periodStart, DateTime periodEnd, ActivityModel? activity, HealthSummaryResponse? summary, ActivityModel? summarySource, String? errorMessage, List<String> unavailableMetrics
});


$ActivityModelCopyWith<$Res>? get activity;$HealthSummaryResponseCopyWith<$Res>? get summary;$ActivityModelCopyWith<$Res>? get summarySource;

}
/// @nodoc
class _$KnowledgeStateCopyWithImpl<$Res>
    implements $KnowledgeStateCopyWith<$Res> {
  _$KnowledgeStateCopyWithImpl(this._self, this._then);

  final KnowledgeState _self;
  final $Res Function(KnowledgeState) _then;

/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? periodStart = null,Object? periodEnd = null,Object? activity = freezed,Object? summary = freezed,Object? summarySource = freezed,Object? errorMessage = freezed,Object? unavailableMetrics = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as KnowledgePhase,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityModel?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as HealthSummaryResponse?,summarySource: freezed == summarySource ? _self.summarySource : summarySource // ignore: cast_nullable_to_non_nullable
as ActivityModel?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,unavailableMetrics: null == unavailableMetrics ? _self.unavailableMetrics : unavailableMetrics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of KnowledgeState
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
}/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthSummaryResponseCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $HealthSummaryResponseCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<$Res>? get summarySource {
    if (_self.summarySource == null) {
    return null;
  }

  return $ActivityModelCopyWith<$Res>(_self.summarySource!, (value) {
    return _then(_self.copyWith(summarySource: value));
  });
}
}


/// Adds pattern-matching-related methods to [KnowledgeState].
extension KnowledgeStatePatterns on KnowledgeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KnowledgeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KnowledgeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KnowledgeState value)  $default,){
final _that = this;
switch (_that) {
case _KnowledgeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KnowledgeState value)?  $default,){
final _that = this;
switch (_that) {
case _KnowledgeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KnowledgePhase phase,  DateTime periodStart,  DateTime periodEnd,  ActivityModel? activity,  HealthSummaryResponse? summary,  ActivityModel? summarySource,  String? errorMessage,  List<String> unavailableMetrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KnowledgeState() when $default != null:
return $default(_that.phase,_that.periodStart,_that.periodEnd,_that.activity,_that.summary,_that.summarySource,_that.errorMessage,_that.unavailableMetrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KnowledgePhase phase,  DateTime periodStart,  DateTime periodEnd,  ActivityModel? activity,  HealthSummaryResponse? summary,  ActivityModel? summarySource,  String? errorMessage,  List<String> unavailableMetrics)  $default,) {final _that = this;
switch (_that) {
case _KnowledgeState():
return $default(_that.phase,_that.periodStart,_that.periodEnd,_that.activity,_that.summary,_that.summarySource,_that.errorMessage,_that.unavailableMetrics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KnowledgePhase phase,  DateTime periodStart,  DateTime periodEnd,  ActivityModel? activity,  HealthSummaryResponse? summary,  ActivityModel? summarySource,  String? errorMessage,  List<String> unavailableMetrics)?  $default,) {final _that = this;
switch (_that) {
case _KnowledgeState() when $default != null:
return $default(_that.phase,_that.periodStart,_that.periodEnd,_that.activity,_that.summary,_that.summarySource,_that.errorMessage,_that.unavailableMetrics);case _:
  return null;

}
}

}

/// @nodoc


class _KnowledgeState extends KnowledgeState {
  const _KnowledgeState({required this.phase, required this.periodStart, required this.periodEnd, this.activity, this.summary, this.summarySource, this.errorMessage, final  List<String> unavailableMetrics = const <String>[]}): _unavailableMetrics = unavailableMetrics,super._();
  

@override final  KnowledgePhase phase;
@override final  DateTime periodStart;
@override final  DateTime periodEnd;
@override final  ActivityModel? activity;
@override final  HealthSummaryResponse? summary;
/// The activity snapshot the current [summary] was generated from,
/// used to avoid regenerating a summary for unchanged data.
@override final  ActivityModel? summarySource;
/// User-friendly error description. Never a raw exception/stack trace.
@override final  String? errorMessage;
/// Names of the metrics the user has not granted access to.
 final  List<String> _unavailableMetrics;
/// Names of the metrics the user has not granted access to.
@override@JsonKey() List<String> get unavailableMetrics {
  if (_unavailableMetrics is EqualUnmodifiableListView) return _unavailableMetrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unavailableMetrics);
}


/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnowledgeStateCopyWith<_KnowledgeState> get copyWith => __$KnowledgeStateCopyWithImpl<_KnowledgeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnowledgeState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.summarySource, summarySource) || other.summarySource == summarySource)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._unavailableMetrics, _unavailableMetrics));
}


@override
int get hashCode => Object.hash(runtimeType,phase,periodStart,periodEnd,activity,summary,summarySource,errorMessage,const DeepCollectionEquality().hash(_unavailableMetrics));

@override
String toString() {
  return 'KnowledgeState(phase: $phase, periodStart: $periodStart, periodEnd: $periodEnd, activity: $activity, summary: $summary, summarySource: $summarySource, errorMessage: $errorMessage, unavailableMetrics: $unavailableMetrics)';
}


}

/// @nodoc
abstract mixin class _$KnowledgeStateCopyWith<$Res> implements $KnowledgeStateCopyWith<$Res> {
  factory _$KnowledgeStateCopyWith(_KnowledgeState value, $Res Function(_KnowledgeState) _then) = __$KnowledgeStateCopyWithImpl;
@override @useResult
$Res call({
 KnowledgePhase phase, DateTime periodStart, DateTime periodEnd, ActivityModel? activity, HealthSummaryResponse? summary, ActivityModel? summarySource, String? errorMessage, List<String> unavailableMetrics
});


@override $ActivityModelCopyWith<$Res>? get activity;@override $HealthSummaryResponseCopyWith<$Res>? get summary;@override $ActivityModelCopyWith<$Res>? get summarySource;

}
/// @nodoc
class __$KnowledgeStateCopyWithImpl<$Res>
    implements _$KnowledgeStateCopyWith<$Res> {
  __$KnowledgeStateCopyWithImpl(this._self, this._then);

  final _KnowledgeState _self;
  final $Res Function(_KnowledgeState) _then;

/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? periodStart = null,Object? periodEnd = null,Object? activity = freezed,Object? summary = freezed,Object? summarySource = freezed,Object? errorMessage = freezed,Object? unavailableMetrics = null,}) {
  return _then(_KnowledgeState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as KnowledgePhase,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,activity: freezed == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as ActivityModel?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as HealthSummaryResponse?,summarySource: freezed == summarySource ? _self.summarySource : summarySource // ignore: cast_nullable_to_non_nullable
as ActivityModel?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,unavailableMetrics: null == unavailableMetrics ? _self._unavailableMetrics : unavailableMetrics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of KnowledgeState
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
}/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthSummaryResponseCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $HealthSummaryResponseCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of KnowledgeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<$Res>? get summarySource {
    if (_self.summarySource == null) {
    return null;
  }

  return $ActivityModelCopyWith<$Res>(_self.summarySource!, (value) {
    return _then(_self.copyWith(summarySource: value));
  });
}
}

// dart format on
