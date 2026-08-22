import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/chat_bot/models/response.model.dart';
import 'package:client/feature/chat_bot/repository/bot.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bot.service.g.dart';

@riverpod
BotService botService(Ref ref) => BotService(ref);

class BotService {
  final Ref ref;

  BotService(this.ref);

  BotRepositoryImpService get _repository =>
      ref.read(botRepositoryImpServiceProvider);

  Future<ChatResponseModel> sendMessage(String value) async {
    try {
      if (value.isEmpty) {
        throw Exception("Enter Your Questions");
      }

      final res = await _repository.sendInfo(value);
      return res;
    } on AppException {
      rethrow;
    } catch (e) {
      throw Exception(e);
    }
  }
}
