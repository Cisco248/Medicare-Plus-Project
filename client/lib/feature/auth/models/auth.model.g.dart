// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    _AuthResponseModel(
      token: json['token'] as String? ?? '',
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      mobnum: json['mobnum'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$AuthResponseModelToJson(_AuthResponseModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'mobnum': instance.mobnum,
      'password': instance.password,
    };
