import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void changeIndex(int index) {
    state = index;
  }
}

final navigationProvider = NotifierProvider<NavigationNotifier, int>(
  NavigationNotifier.new,
);
