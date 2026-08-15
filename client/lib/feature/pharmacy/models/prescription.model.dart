enum PrescriptionStatus {
  notSubmitted('Not Submitted'),
  pendingVerification('Pending Verification'),
  approved('Approved'),
  rejected('Rejected');

  const PrescriptionStatus(this.label);
  final String label;
}

class PrescriptionRecord {
  const PrescriptionRecord({
    required this.productId,
    this.status = PrescriptionStatus.notSubmitted,
    this.documentId,
    this.fileName,
  });

  final String productId;
  final PrescriptionStatus status;
  final String? documentId;
  final String? fileName;

  bool get canPurchase => status == PrescriptionStatus.approved;

  PrescriptionRecord copyWith({
    PrescriptionStatus? status,
    String? documentId,
    String? fileName,
  }) {
    return PrescriptionRecord(
      productId: productId,
      status: status ?? this.status,
      documentId: documentId ?? this.documentId,
      fileName: fileName ?? this.fileName,
    );
  }

  Map<String, Object?> toJson() => {
    'productId': productId,
    'status': status.name,
    'documentId': documentId,
    'fileName': fileName,
  };

  factory PrescriptionRecord.fromJson(Map<String, dynamic> json) =>
      PrescriptionRecord(
        productId: json['productId'] as String,
        status: PrescriptionStatus.values.firstWhere(
          (value) => value.name == json['status'],
          orElse: () => PrescriptionStatus.notSubmitted,
        ),
        documentId: json['documentId'] as String?,
        fileName: json['fileName'] as String?,
      );
}
