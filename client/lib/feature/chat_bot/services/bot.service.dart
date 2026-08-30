import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/chat_bot/models/response.model.dart';
import 'package:client/feature/chat_bot/repository/bot.repository.dart';
import 'package:client/feature/dashboard/notifiers/clinical_snapshot.notifier.dart';
import 'package:client/feature/e_doc/notifiers/edoc_chat_context.notifier.dart';
import 'package:client/feature/e_doc/utils/edoc_chat_context.dart';
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

      final res = await _repository.sendInfo(
        value,
        patientContext: combineChatContext(
          edocContext: ref.read(edocChatContextProvider),
          snapshotContext: snapshotChatContext(ref.read(clinicalSnapshotProvider)),
        ),
      );
      return res;
    } on AppException {
      rethrow;
    } catch (e) {
      throw Exception(e);
    }
  }
}
