import 'package:client/core/utils/dio.client.dart';
import 'package:client/feature/pharmacy/models/medicine.model.dart';
import 'package:client/feature/pharmacy/repositories/pharma.repository.dart';

class PharmacyService {
  final _repository = PharmaRepository(client: physicalDevice(8080));

  Future<List<MedicineModel>> fetchMedicines() async {
    try {
      final res = await _repository.fetchMedicines();
      return res
          .map(
            (e) => MedicineModel(
              medicineName: e.medicineName,
              category: MedicineCategory.values[e.category.index],
              dosage: e.dosage,
              price: e.price,
              imgPath: e.imgPath,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch medicines: $e');
    }
  }

  Future<List<MedicineModel>> searchMedicines(String query) async {
    try {
      final res = await _repository.searchMedicines(query);
      return res.map((e) => MedicineModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to search medicines: $e');
    }
  }
}
