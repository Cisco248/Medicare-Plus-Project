import 'package:client/feature/e_doc/models/assessment.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form.notifier.g.dart';

@riverpod
class EDocModelNotifier extends _$EDocModelNotifier {
  @override
  EDocPredictionModel build() => EDocPredictionModel.diabetes;

  void select(EDocPredictionModel model) {
    state = model;
  }
}
