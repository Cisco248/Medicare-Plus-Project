import 'package:client/data/models/medicine_model.dart';
import 'package:dio/dio.dart';

class PharmaRepository {
  final Dio _client;

  PharmaRepository({required this._client});

  Future<List<MedicineModel>> fetchMedicines() async {
    try {
      // final response = await _client.get('/products');
      return [
        MedicineModel(
          medicineName: 'Panadol Local',
          category: MedicineCategory.tablet,
          dosage: 10,
          price: 200.0,
          imgPath: 'assets/images/panadol.png',
        ),
        MedicineModel(
          medicineName: 'Panadol Local',
          category: MedicineCategory.tablet,
          dosage: 10,
          price: 200.0,
          imgPath: 'assets/images/panadol.png',
        ),
      ];
    } on DioException catch (e) {
      final message =
          'Status: ${e.response?.statusCode}, Message: ${e.message}';
      throw Exception('Login failed: $message');
    }
  }

  Future<List> searchMedicines(String query) async {
    try {
      final response = await _client.get(
        '/products',
        queryParameters: {'query': query},
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          'Status: ${e.response?.statusCode}, Message: ${e.message}';
      throw Exception('Search failed: $message');
    }
  }
}
