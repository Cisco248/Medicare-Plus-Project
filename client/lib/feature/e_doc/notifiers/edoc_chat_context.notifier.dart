import 'package:flutter_riverpod/flutter_riverpod.dart';

class EdocChatContextNotifier extends Notifier<String> {
  @override
  String build() => '';

  void replace(String value) => state = value.trim();

  void clear() => state = '';
}

final edocChatContextProvider =
    NotifierProvider<EdocChatContextNotifier, String>(EdocChatContextNotifier.new);
