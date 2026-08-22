import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/repositories/pharma.repository.dart';

class PharmacyService {
  PharmacyService({PharmaRepository? repository})
    : _repository = repository ?? const PharmaRepository();

  final PharmaRepository _repository;

  Future<List<PharmacyProduct>> fetchMedicines() => _repository.fetchProducts();

  Future<List<PharmacyProduct>> searchMedicines(String query) =>
      _repository.searchProducts(query);
}
