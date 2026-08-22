import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.model.freezed.dart';
part 'document.model.g.dart';

enum DocumentStatus {
  uploaded('uploaded', 'Uploaded'),
  processing('processing', 'Processing'),
  reviewed('reviewed', 'Reviewed'),
  rejected('rejected', 'Rejected');

  const DocumentStatus(this.value, this.label);

  final String value;

  final String label;

  static DocumentStatus fromValue(String value) =>
      DocumentStatus.values.firstWhere(
        (status) => status.value == value.toLowerCase(),
        orElse: () => DocumentStatus.uploaded,
      );
}

@freezed
abstract class DocumentModel with _$DocumentModel {
  const DocumentModel._();

  const factory DocumentModel({
    required String id,
    required String userId,
    required String title,
    required String docType,
    required String fileName,
    required String fileType,
    String? description,
    String? issuer,
    String? hospital,
    DateTime? reportDate,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, Object?> json) =>
      _$DocumentModelFromJson(json);

  DocumentStatus get documentStatus => DocumentStatus.fromValue(status);

  bool get isImage =>
      fileType == 'jpg' || fileType == 'jpeg' || fileType == 'png';

  bool get isDemo => userId == 'demo';
}
