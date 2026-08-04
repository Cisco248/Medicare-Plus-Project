import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popup.notifier.g.dart';

@riverpod
class PopUpNotifier extends _$PopUpNotifier {
  @override
  bool build() {
    return state = false;
  }

  void toggle() {
    state = !state;
  }
}
