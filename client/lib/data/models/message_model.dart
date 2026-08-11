enum MessageType { user, bot }

class MessageModel {
  final String id;
  final MessageType type;
  final DateTime createdAt;
  final String message;

  MessageModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.message,
  });
}
