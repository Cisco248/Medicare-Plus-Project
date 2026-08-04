import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drawer.notifier.g.dart';

@riverpod
class DrawerNotifier extends _$DrawerNotifier {
  @override
  bool build() => false;

  bool toggle() => state == false ? true : false;
}
