// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppPermissionItem _$AppPermissionItemFromJson(Map<String, dynamic> json) =>
    _AppPermissionItem(
      kind: $enumDecode(_$AppPermissionKindEnumMap, json['kind']),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      status: $enumDecode(_$AppPermissionStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AppPermissionItemToJson(_AppPermissionItem instance) =>
    <String, dynamic>{
      'kind': _$AppPermissionKindEnumMap[instance.kind]!,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'status': _$AppPermissionStatusEnumMap[instance.status]!,
    };

const _$AppPermissionKindEnumMap = {
  AppPermissionKind.healthConnect: 'healthConnect',
  AppPermissionKind.fileAccess: 'fileAccess',
};

const _$AppPermissionStatusEnumMap = {
  AppPermissionStatus.allowed: 'allowed',
  AppPermissionStatus.notAllowed: 'notAllowed',
  AppPermissionStatus.required: 'required',
  AppPermissionStatus.unavailable: 'unavailable',
};
