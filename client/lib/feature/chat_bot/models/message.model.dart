import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.model.freezed.dart';

enum MessageType { user, bot }

@freezed
abstract class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    required String id,
    required MessageType type,
    required DateTime createdAt,
    @Default('') String? message,
  }) = _ChatMessageModel;
}
