// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    _DocumentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      docType: json['doc_type'] as String,
      fileName: json['file_name'] as String,
      fileType: json['file_type'] as String,
      description: json['description'] as String?,
      issuer: json['issuer'] as String?,
      hospital: json['hospital'] as String?,
      reportDate: json['report_date'] == null
          ? null
          : DateTime.parse(json['report_date'] as String),
      status: json['status'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DocumentModelToJson(_DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'doc_type': instance.docType,
      'file_name': instance.fileName,
      'file_type': instance.fileType,
      'description': instance.description,
      'issuer': instance.issuer,
      'hospital': instance.hospital,
      'report_date': instance.reportDate?.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
