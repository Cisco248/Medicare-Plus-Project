import 'package:client/core/utils/exception.utils.dart';
import 'package:dio/dio.dart';

class KnowledgeRepository {
  final Dio _client;

  KnowledgeRepository({required this._client});

  Future<void> sendData(Map<String, Object?> data) async {
    try {
      final response = await _client.post('/knowledge', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        throw BaseException(
          requestOptions: RequestOptions(),
          message: response.statusMessage,
          error: response.statusMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw BaseException(requestOptions: RequestOptions(), error: e);
    }
  }

  Future<String> getStoredData() async {
    try {
      return '';
    } catch (e) {
      throw BaseException(requestOptions: RequestOptions(), error: e);
    }
  }
}
