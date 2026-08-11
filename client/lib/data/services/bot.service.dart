import 'package:client/data/repository/bot.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bot.service.g.dart';

@riverpod
BotService botService(Ref ref) => BotService(ref);

class BotService {
  final Ref ref;
  BotService(this.ref);

  BotRepositoryImpService get _repository =>
      ref.read(botRepositoryImpServiceProvider);

  Future<String> infoService(String info) async {
    try {
      return await _repository.sendInfo(info);
    } catch (e) {
      return "Error: $e";
    }
  }
}
