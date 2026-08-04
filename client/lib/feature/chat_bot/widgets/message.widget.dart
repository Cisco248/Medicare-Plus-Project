import 'package:client/feature/chat_bot/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final bool variant;
  final MessageModel message;

  const MessageWidget({
    super.key,
    required this.variant,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: variant ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: variant
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                variant
                    ? "Question: ${message.message}"
                    : 'Answer: ${message.message}',
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: variant ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
