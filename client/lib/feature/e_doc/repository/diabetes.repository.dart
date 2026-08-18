import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:dio/dio.dart';

class DiabetesRepository {
  final Dio dio;

  DiabetesRepository({required this.dio});

  Future<DiabetesResultModel> predict(DiabetesModel request) async {
    final response = await dio.post(
      '/api/predict/diabetes',
      data: request.toJson(),
    );
    return DiabetesResultModel.fromJson(response.data);
  }
}
