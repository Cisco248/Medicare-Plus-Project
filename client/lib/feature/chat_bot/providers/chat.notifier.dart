import 'package:client/feature/chat_bot/models/chat_state.model.dart';
import 'package:client/feature/chat_bot/models/message_model.dart';
import 'package:client/feature/chat_bot/services/bot.service.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat.notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  final _uuid = const Uuid();

  BotService get botService => ref.watch(botServiceProvider);

  @override
  ChatState build() {
    return ChatState(messages: [], isLoading: false);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = MessageModel(
      id: _uuid.v4(),
      message: text,
      type: MessageType.user,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final response = await botService.infoService(text);

      final botMessage = MessageModel(
        id: _uuid.v4(),
        type: MessageType.bot,
        createdAt: DateTime.now(),
        message: response,
      );
      if (kDebugMode) print(botMessage);

      state = state.copyWith(
        messages: [...state.messages, botMessage],
        isLoading: false,
      );
    } catch (e) {
      final errorMessage = MessageModel(
        id: _uuid.v4(),
        type: MessageType.bot,
        createdAt: DateTime.now(),
        message: e.toString(),
      );
      state = state.copyWith(
        isLoading: false,
        messages: [...state.messages, errorMessage],
      );
    }
  }
}
