// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrescriptionRecord {

 String get productId; PrescriptionStatus? get status; String? get documentId; String? get fileName;
/// Create a copy of PrescriptionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionRecordCopyWith<PrescriptionRecord> get copyWith => _$PrescriptionRecordCopyWithImpl<PrescriptionRecord>(this as PrescriptionRecord, _$identity);

  /// Serializes this PrescriptionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionRecord&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.status, status) || other.status == status)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,status,documentId,fileName);

@override
String toString() {
  return 'PrescriptionRecord(productId: $productId, status: $status, documentId: $documentId, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class $PrescriptionRecordCopyWith<$Res>  {
  factory $PrescriptionRecordCopyWith(PrescriptionRecord value, $Res Function(PrescriptionRecord) _then) = _$PrescriptionRecordCopyWithImpl;
@useResult
$Res call({
 String productId, PrescriptionStatus? status, String? documentId, String? fileName
});




}
/// @nodoc
class _$PrescriptionRecordCopyWithImpl<$Res>
    implements $PrescriptionRecordCopyWith<$Res> {
  _$PrescriptionRecordCopyWithImpl(this._self, this._then);

  final PrescriptionRecord _self;
  final $Res Function(PrescriptionRecord) _then;

/// Create a copy of PrescriptionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? status = freezed,Object? documentId = freezed,Object? fileName = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrescriptionStatus?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrescriptionRecord].
extension PrescriptionRecordPatterns on PrescriptionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionRecord value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  PrescriptionStatus? status,  String? documentId,  String? fileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionRecord() when $default != null:
return $default(_that.productId,_that.status,_that.documentId,_that.fileName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  PrescriptionStatus? status,  String? documentId,  String? fileName)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionRecord():
return $default(_that.productId,_that.status,_that.documentId,_that.fileName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  PrescriptionStatus? status,  String? documentId,  String? fileName)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionRecord() when $default != null:
return $default(_that.productId,_that.status,_that.documentId,_that.fileName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionRecord extends PrescriptionRecord {
  const _PrescriptionRecord({required this.productId, this.status = null, this.documentId = null, this.fileName = null}): super._();
  factory _PrescriptionRecord.fromJson(Map<String, dynamic> json) => _$PrescriptionRecordFromJson(json);

@override final  String productId;
@override@JsonKey() final  PrescriptionStatus? status;
@override@JsonKey() final  String? documentId;
@override@JsonKey() final  String? fileName;

/// Create a copy of PrescriptionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionRecordCopyWith<_PrescriptionRecord> get copyWith => __$PrescriptionRecordCopyWithImpl<_PrescriptionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionRecord&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.status, status) || other.status == status)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,status,documentId,fileName);

@override
String toString() {
  return 'PrescriptionRecord(productId: $productId, status: $status, documentId: $documentId, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionRecordCopyWith<$Res> implements $PrescriptionRecordCopyWith<$Res> {
  factory _$PrescriptionRecordCopyWith(_PrescriptionRecord value, $Res Function(_PrescriptionRecord) _then) = __$PrescriptionRecordCopyWithImpl;
@override @useResult
$Res call({
 String productId, PrescriptionStatus? status, String? documentId, String? fileName
});




}
/// @nodoc
class __$PrescriptionRecordCopyWithImpl<$Res>
    implements _$PrescriptionRecordCopyWith<$Res> {
  __$PrescriptionRecordCopyWithImpl(this._self, this._then);

  final _PrescriptionRecord _self;
  final $Res Function(_PrescriptionRecord) _then;

/// Create a copy of PrescriptionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? status = freezed,Object? documentId = freezed,Object? fileName = freezed,}) {
  return _then(_PrescriptionRecord(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PrescriptionStatus?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
