import 'package:client/data/models/response.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:dio/dio.dart';

class HypertensionRepository {
  final Dio _client;

  HypertensionRepository({required this._client});

  Future<ResponseModel> sendData(HypertensionModel data) async {
    final response = await _client.post('/hypertension', data: data);
    if (response.statusCode != 200) {
      throw Exception('Failed to send data');
    }
    return ResponseModel(
      message: 'Data Send Successfully',
      body: response.data,
    );
  }
}
