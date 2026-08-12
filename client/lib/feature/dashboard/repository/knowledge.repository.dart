import 'package:client/core/exceptions/basic.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:dio/dio.dart';

class KnowledgeRepository {
  final Dio _client;

  KnowledgeRepository({required this._client});

  Future<void> sendData(ActivityModel data) async {
    try {
      final response = await _client.post(
        '/knowledge',
        data: ActivityModel(
          steps: data.steps,
          walking: data.walking,
          running: data.running,
          climbing: data.climbing,
          sleeping: data.sleeping,
        ).toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        throw NetworkException(
          details: response.statusMessage,
          code: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(details: e);
    }
  }

  Future<String> getStoredData() async {
    try {
      return '';
    } catch (e) {
      throw ServerException(details: e);
    }
  }
}
