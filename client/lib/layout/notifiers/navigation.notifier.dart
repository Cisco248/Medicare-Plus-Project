import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation.notifier.g.dart';

@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  @override
  int build() => 0;

  void changeIndex(int index) {
    state = index;
  }
}
