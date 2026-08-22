import 'package:client/feature/pharmacy/models/prescription.model.dart';
import 'package:client/feature/pharmacy/repositories/pharmacy_store.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prescription.notifier.g.dart';

final _store = PharmacyStoreRepository();

@riverpod
class PrescriptionNotifier extends _$PrescriptionNotifier {
  @override
  Future<Map<String, PrescriptionRecord>> build() async =>
      await _store.loadPrescriptions();

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
    await _store.savePrescriptions(current);
  }

  Future<void> simulateDecision(
    String productId, {
    required bool approve,
  }) async {
    final current = Map<String, PrescriptionRecord>.from(state.value ?? {});
    final existing =
        current[productId] ?? PrescriptionRecord(productId: productId);
    current[productId] = existing.copyWith(
      status: approve
          ? PrescriptionStatus.approved
          : PrescriptionStatus.rejected,
    );
    state = AsyncData(current);
    await _store.savePrescriptions(current);
  }
}

@riverpod
class PrescriptionRec extends _$PrescriptionRec {
  @override
  Map<String, PrescriptionRecord> build() {
    final prescriptions = ref.watch(prescriptionProvider);
    final val = prescriptions.asData!.value;
    return val;
  }
}

// final prescriptionProvider = Provider<Map<String, PrescriptionRecord>>((ref) {
//   return ref.watch(prescriptionRecordsProvider).value ?? const {};
// });
