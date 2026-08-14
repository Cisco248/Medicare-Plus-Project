// @JsonSerializable on freezed factory constructors is the documented way to
// configure json_serializable for freezed classes.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.model.freezed.dart';
part 'document.model.g.dart';

/// Statuses a medical document can be in on the backend.
enum DocumentStatus {
  uploaded('uploaded', 'Uploaded'),
  processing('processing', 'Processing'),
  reviewed('reviewed', 'Reviewed'),
  rejected('rejected', 'Rejected');

  const DocumentStatus(this.value, this.label);

  /// The raw status string stored by the backend.
  final String value;

  /// User-facing label.
  final String label;

  static DocumentStatus fromValue(String value) =>
      DocumentStatus.values.firstWhere(
        (status) => status.value == value.toLowerCase(),
        orElse: () => DocumentStatus.uploaded,
      );
}

/// A patient's uploaded medical report/document as returned by the backend.
@freezed
abstract class DocumentModel with _$DocumentModel {
  const DocumentModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
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
