import 'dart:convert';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bot.repository.g.dart';

@riverpod
BotRepositoryImpService botRepositoryImpService(Ref ref) =>
    BotRepositoryImpService();

abstract class BotRepository {
  Future<String> sendInfo(String? info);
}

class BotRepositoryImpService extends BotRepository {
  final client = Client();
  BotRepositoryImpService();

  @override
  Future<String> sendInfo(String? value) async {
    if (value == null) 'Value Not Found!';
    try {
      final response = await client.post(
        Uri.http('192.168.2.49:8000', '/api/ask'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'question': value}),
      );
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      return Exception('Error: $e').toString();
    }
  }
}
