import 'package:client/core/network/dio_client.dart';
import 'package:client/feature/chat_bot/models/response.model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bot.repository.g.dart';

@riverpod
BotRepositoryImpService botRepositoryImpService(Ref ref) =>
    BotRepositoryImpService(client: client(8000));

abstract class BotRepository {
  Future<ChatResponseModel> sendInfo(String info);
}

class BotRepositoryImpService extends BotRepository {
  final Dio _client;

  BotRepositoryImpService({required this._client});

  @override
  Future<ChatResponseModel> sendInfo(String value) async {
    if (value.isEmpty) throw Exception('Value Not Found!');
    try {
      final response = await _client.post('/ask', data: {'question': value});
      return ChatResponseModel(
        message: response.data.toString(),
        createdDate: DateTime.now(),
      );
    } on DioException catch (e) {
      final message =
          'Status: ${e.response!.statusCode}, Message: ${e.message}';
      throw Exception(message);
    }
  }
}
