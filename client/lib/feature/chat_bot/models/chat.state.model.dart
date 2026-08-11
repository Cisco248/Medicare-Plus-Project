import 'package:client/feature/chat_bot/models/message.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.state.model.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(<ChatMessageModel>[]) List<ChatMessageModel> messages,
    @Default(false) bool isLoading,
  }) = _ChatState;
}
