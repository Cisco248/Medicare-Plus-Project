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
mixin _$AuthResponseModel {

 String get token; String get id; String get email; String get name; String get mobnum; String get password;
/// Create a copy of AuthResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthResponseModelCopyWith<AuthResponseModel> get copyWith => _$AuthResponseModelCopyWithImpl<AuthResponseModel>(this as AuthResponseModel, _$identity);

  /// Serializes this AuthResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResponseModel&&(identical(other.token, token) || other.token == token)&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobnum, mobnum) || other.mobnum == mobnum)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,id,email,name,mobnum,password);

@override
String toString() {
  return 'AuthResponseModel(token: $token, id: $id, email: $email, name: $name, mobnum: $mobnum, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthResponseModelCopyWith<$Res>  {
  factory $AuthResponseModelCopyWith(AuthResponseModel value, $Res Function(AuthResponseModel) _then) = _$AuthResponseModelCopyWithImpl;
@useResult
$Res call({
 String token, String id, String email, String name, String mobnum, String password
});




}
/// @nodoc
class _$AuthResponseModelCopyWithImpl<$Res>
    implements $AuthResponseModelCopyWith<$Res> {
  _$AuthResponseModelCopyWithImpl(this._self, this._then);

  final AuthResponseModel _self;
  final $Res Function(AuthResponseModel) _then;

/// Create a copy of AuthResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? id = null,Object? email = null,Object? name = null,Object? mobnum = null,Object? password = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobnum: null == mobnum ? _self.mobnum : mobnum // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthResponseModel].
extension AuthResponseModelPatterns on AuthResponseModel {
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthResponseModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthResponseModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthResponseModel() when $default != null:
return $default(_that);case _:
  return null;

}
}

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String id,  String email,  String name,  String mobnum,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthResponseModel() when $default != null:
return $default(_that.token,_that.id,_that.email,_that.name,_that.mobnum,_that.password);case _:
  return orElse();

}
}

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String id,  String email,  String name,  String mobnum,  String password)  $default,) {final _that = this;
switch (_that) {
case _AuthResponseModel():
return $default(_that.token,_that.id,_that.email,_that.name,_that.mobnum,_that.password);case _:
  throw StateError('Unexpected subclass');

}
}

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String id,  String email,  String name,  String mobnum,  String password)?  $default,) {final _that = this;
switch (_that) {
case _AuthResponseModel() when $default != null:
return $default(_that.token,_that.id,_that.email,_that.name,_that.mobnum,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthResponseModel implements AuthResponseModel {
  const _AuthResponseModel({this.token = '', this.id = '', this.email = '', this.name = '', this.mobnum = '', this.password = ''});
  factory _AuthResponseModel.fromJson(Map<String, dynamic> json) => _$AuthResponseModelFromJson(json);

@override@JsonKey() final  String token;
@override@JsonKey() final  String id;
@override@JsonKey() final  String email;
@override@JsonKey() final  String name;
@override@JsonKey() final  String mobnum;
@override@JsonKey() final  String password;

/// Create a copy of AuthResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthResponseModelCopyWith<_AuthResponseModel> get copyWith => __$AuthResponseModelCopyWithImpl<_AuthResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthResponseModel&&(identical(other.token, token) || other.token == token)&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.mobnum, mobnum) || other.mobnum == mobnum)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,id,email,name,mobnum,password);

@override
String toString() {
  return 'AuthResponseModel(token: $token, id: $id, email: $email, name: $name, mobnum: $mobnum, password: $password)';
}


}

/// @nodoc
abstract mixin class _$AuthResponseModelCopyWith<$Res> implements $AuthResponseModelCopyWith<$Res> {
  factory _$AuthResponseModelCopyWith(_AuthResponseModel value, $Res Function(_AuthResponseModel) _then) = __$AuthResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String token, String id, String email, String name, String mobnum, String password
});




}
/// @nodoc
class __$AuthResponseModelCopyWithImpl<$Res>
    implements _$AuthResponseModelCopyWith<$Res> {
  __$AuthResponseModelCopyWithImpl(this._self, this._then);

  final _AuthResponseModel _self;
  final $Res Function(_AuthResponseModel) _then;

/// Create a copy of AuthResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? id = null,Object? email = null,Object? name = null,Object? mobnum = null,Object? password = null,}) {
  return _then(_AuthResponseModel(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobnum: null == mobnum ? _self.mobnum : mobnum // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}

// dart format on
