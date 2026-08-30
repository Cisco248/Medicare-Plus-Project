import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/network/dio_client.dart';
import 'package:client/feature/chat_bot/models/response.model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bot.repository.g.dart';

@riverpod
BotRepositoryImpService botRepositoryImpService(Ref ref) =>
    BotRepositoryImpService(client: ragClient());

abstract class BotRepository {
  Future<ChatResponseModel> sendInfo(String info, {String? patientContext});
}

class BotRepositoryImpService extends BotRepository {
  final Dio _client;

  BotRepositoryImpService({required this._client});

  @override
  Future<ChatResponseModel> sendInfo(
    String value, {
    String? patientContext,
  }) async {
    if (value.isEmpty) throw Exception('Value Not Found!');
    try {
      final payload = <String, dynamic>{'question': value};
      if (patientContext != null && patientContext.trim().isNotEmpty) {
        payload['patient_context'] = patientContext.trim();
      }
      final response = await _client.post('/api/ask', data: payload);
      return ChatResponseModel(
        message: response.data.toString(),
        createdDate: DateTime.now(),
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}
