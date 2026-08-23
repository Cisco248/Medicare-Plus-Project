// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrescriptionRecord _$PrescriptionRecordFromJson(Map<String, dynamic> json) =>
    _PrescriptionRecord(
      productId: json['productId'] as String,
      status:
          $enumDecodeNullable(_$PrescriptionStatusEnumMap, json['status']) ??
          null,
      documentId: json['documentId'] as String? ?? null,
      fileName: json['fileName'] as String? ?? null,
    );

Map<String, dynamic> _$PrescriptionRecordToJson(_PrescriptionRecord instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'status': _$PrescriptionStatusEnumMap[instance.status],
      'documentId': instance.documentId,
      'fileName': instance.fileName,
    };

const _$PrescriptionStatusEnumMap = {
  PrescriptionStatus.notSubmitted: 'notSubmitted',
  PrescriptionStatus.pendingVerification: 'pendingVerification',
  PrescriptionStatus.approved: 'approved',
  PrescriptionStatus.rejected: 'rejected',
};
