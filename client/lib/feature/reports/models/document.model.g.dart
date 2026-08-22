// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    _DocumentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      docType: json['docType'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      description: json['description'] as String?,
      issuer: json['issuer'] as String?,
      hospital: json['hospital'] as String?,
      reportDate: json['reportDate'] == null
          ? null
          : DateTime.parse(json['reportDate'] as String),
      status: json['status'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DocumentModelToJson(_DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'docType': instance.docType,
      'fileName': instance.fileName,
      'fileType': instance.fileType,
      'description': instance.description,
      'issuer': instance.issuer,
      'hospital': instance.hospital,
      'reportDate': instance.reportDate?.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
