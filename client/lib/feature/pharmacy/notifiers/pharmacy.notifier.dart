import 'package:client/feature/pharmacy/models/medicine.model.dart';
import 'package:client/feature/pharmacy/services/pharmacy.service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pharmacy.notifier.g.dart';

@riverpod
class PharmacyNotifier extends _$PharmacyNotifier {
  @override
  Future<List<MedicineModel>> build() async {
    try {
      final res = await PharmacyService().fetchMedicines();
      return res;
    } catch (_) {
      return [];
    }
  }

  Future<void> searchMedicines(String query) async {
    try {
      final res = await PharmacyService().searchMedicines(query);
      state = AsyncValue.data(res);
    } catch (_) {
      state = AsyncValue.data([]);
    }
  }
}
