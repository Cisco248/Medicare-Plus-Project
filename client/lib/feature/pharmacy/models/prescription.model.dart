import 'package:freezed_annotation/freezed_annotation.dart';

part 'prescription.model.freezed.dart';
part 'prescription.model.g.dart';

enum PrescriptionStatus {
  notSubmitted('Not Submitted'),
  pendingVerification('Pending Verification'),
  approved('Approved'),
  rejected('Rejected');

  const PrescriptionStatus(this.label);
  final String label;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: true)
abstract class PrescriptionRecord with _$PrescriptionRecord {
  const PrescriptionRecord._();

  const factory PrescriptionRecord({
    required String productId,
    @Default(null) PrescriptionStatus? status,
    @Default(null) String? documentId,
    @Default(null) String? fileName,
  }) = _PrescriptionRecord;

  bool get canPurchase => status == PrescriptionStatus.approved;

  factory PrescriptionRecord.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionRecordFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$PrescriptionRecordToJson(this as _PrescriptionRecord);
}
