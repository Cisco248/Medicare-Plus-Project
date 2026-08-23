// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppPermissionItem {

 AppPermissionKind get kind; String get title; String get subtitle; AppPermissionStatus get status;
/// Create a copy of AppPermissionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppPermissionItemCopyWith<AppPermissionItem> get copyWith => _$AppPermissionItemCopyWithImpl<AppPermissionItem>(this as AppPermissionItem, _$identity);

  /// Serializes this AppPermissionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppPermissionItem&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,title,subtitle,status);

@override
String toString() {
  return 'AppPermissionItem(kind: $kind, title: $title, subtitle: $subtitle, status: $status)';
}


}

/// @nodoc
abstract mixin class $AppPermissionItemCopyWith<$Res>  {
  factory $AppPermissionItemCopyWith(AppPermissionItem value, $Res Function(AppPermissionItem) _then) = _$AppPermissionItemCopyWithImpl;
@useResult
$Res call({
 AppPermissionKind kind, String title, String subtitle, AppPermissionStatus status
});




}
/// @nodoc
class _$AppPermissionItemCopyWithImpl<$Res>
    implements $AppPermissionItemCopyWith<$Res> {
  _$AppPermissionItemCopyWithImpl(this._self, this._then);

  final AppPermissionItem _self;
  final $Res Function(AppPermissionItem) _then;

/// Create a copy of AppPermissionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? title = null,Object? subtitle = null,Object? status = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AppPermissionKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppPermissionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AppPermissionItem].
extension AppPermissionItemPatterns on AppPermissionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppPermissionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppPermissionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppPermissionItem value)  $default,){
final _that = this;
switch (_that) {
case _AppPermissionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppPermissionItem value)?  $default,){
final _that = this;
switch (_that) {
case _AppPermissionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppPermissionKind kind,  String title,  String subtitle,  AppPermissionStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppPermissionItem() when $default != null:
return $default(_that.kind,_that.title,_that.subtitle,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppPermissionKind kind,  String title,  String subtitle,  AppPermissionStatus status)  $default,) {final _that = this;
switch (_that) {
case _AppPermissionItem():
return $default(_that.kind,_that.title,_that.subtitle,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppPermissionKind kind,  String title,  String subtitle,  AppPermissionStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AppPermissionItem() when $default != null:
return $default(_that.kind,_that.title,_that.subtitle,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppPermissionItem extends AppPermissionItem {
  const _AppPermissionItem({required this.kind, required this.title, required this.subtitle, required this.status}): super._();
  factory _AppPermissionItem.fromJson(Map<String, dynamic> json) => _$AppPermissionItemFromJson(json);

@override final  AppPermissionKind kind;
@override final  String title;
@override final  String subtitle;
@override final  AppPermissionStatus status;

/// Create a copy of AppPermissionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppPermissionItemCopyWith<_AppPermissionItem> get copyWith => __$AppPermissionItemCopyWithImpl<_AppPermissionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppPermissionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppPermissionItem&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,title,subtitle,status);

@override
String toString() {
  return 'AppPermissionItem(kind: $kind, title: $title, subtitle: $subtitle, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AppPermissionItemCopyWith<$Res> implements $AppPermissionItemCopyWith<$Res> {
  factory _$AppPermissionItemCopyWith(_AppPermissionItem value, $Res Function(_AppPermissionItem) _then) = __$AppPermissionItemCopyWithImpl;
@override @useResult
$Res call({
 AppPermissionKind kind, String title, String subtitle, AppPermissionStatus status
});




}
/// @nodoc
class __$AppPermissionItemCopyWithImpl<$Res>
    implements _$AppPermissionItemCopyWith<$Res> {
  __$AppPermissionItemCopyWithImpl(this._self, this._then);

  final _AppPermissionItem _self;
  final $Res Function(_AppPermissionItem) _then;

/// Create a copy of AppPermissionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? title = null,Object? subtitle = null,Object? status = null,}) {
  return _then(_AppPermissionItem(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AppPermissionKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppPermissionStatus,
  ));
}


}

// dart format on
