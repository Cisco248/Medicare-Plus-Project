import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form.notifier.g.dart';

@riverpod
class EDocModelNotifier extends _$EDocModelNotifier {
  @override
  DocModel build() => DocModel.diabetes;

  void select(DocModel model) {
    state = model;
  }
}
