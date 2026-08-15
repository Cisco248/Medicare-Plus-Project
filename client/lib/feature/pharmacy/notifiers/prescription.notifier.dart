import 'package:client/feature/pharmacy/models/prescription.model.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionNotifier extends AsyncNotifier<Map<String, PrescriptionRecord>> {
  @override
  Future<Map<String, PrescriptionRecord>> build() {
    return ref.read(pharmacyStoreProvider).loadPrescriptions();
  }

  PrescriptionRecord recordFor(String productId) {
    return state.value?[productId] ?? PrescriptionRecord(productId: productId);
  }

  Future<void> submit({
    required String productId,
    String? documentId,
    String? fileName,
  }) async {
    final current = Map<String, PrescriptionRecord>.from(state.value ?? {});
    current[productId] = PrescriptionRecord(
      productId: productId,
      status: PrescriptionStatus.pendingVerification,
      documentId: documentId,
      fileName: fileName,
    );
    state = AsyncData(current);
    await ref.read(pharmacyStoreProvider).savePrescriptions(current);
  }

  Future<void> simulateDecision(String productId, {required bool approve}) async {
    final current = Map<String, PrescriptionRecord>.from(state.value ?? {});
    final existing = current[productId] ?? PrescriptionRecord(productId: productId);
    current[productId] = existing.copyWith(
      status: approve
          ? PrescriptionStatus.approved
          : PrescriptionStatus.rejected,
    );
    state = AsyncData(current);
    await ref.read(pharmacyStoreProvider).savePrescriptions(current);
  }
}

final prescriptionRecordsProvider =
    AsyncNotifierProvider<PrescriptionNotifier, Map<String, PrescriptionRecord>>(
      PrescriptionNotifier.new,
    );

/// Synchronous view of stored prescription records.
final prescriptionProvider = Provider<Map<String, PrescriptionRecord>>((ref) {
  return ref.watch(prescriptionRecordsProvider).value ?? const {};
});
