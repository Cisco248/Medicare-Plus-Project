import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/repository/diabetes.repository.dart';
import 'package:client/feature/e_doc/repository/hypertension.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'doc.state.g.dart';

@Riverpod(keepAlive: true)
class DocStateNotifier extends _$DocStateNotifier {
  @override
  DocState build() => const DocState();

  Future<void> submitHypertension(HypertensionModel data) async {
    state = DocState(phase: DocPhase.loading, model: DocModel.hypertension);
    try {
      state = await ref.read(hypertensionRepositoryProvider).sendData(data);
    } on AppException catch (e) {
      state = DocState(
        phase: DocPhase.error,
        model: DocModel.hypertension,
        errorMessage: e.message,
      );
    } catch (_) {
      state = const DocState(
        phase: DocPhase.error,
        model: DocModel.hypertension,
        errorMessage: 'Unable to generate the hypertension assessment.',
      );
    }
  }

  Future<void> submitDiabetes(DiabetesModel data) async {
    state = DocState(phase: DocPhase.loading, model: DocModel.diabetes);
    try {
      state = await ref.read(diabetesRepositoryProvider).predict(data);
    } on AppException catch (e) {
      state = DocState(
        phase: DocPhase.error,
        model: DocModel.diabetes,
        errorMessage: e.message,
      );
    } catch (_) {
      state = const DocState(
        phase: DocPhase.error,
        model: DocModel.diabetes,
        errorMessage: 'Unable to generate the diabetes assessment.',
      );
    }
  }

  void markUnavailable(DocModel model) {
    state = DocState(
      phase: DocPhase.empty,
      model: model,
      errorMessage: 'This prediction model is not available on the server yet.',
    );
  }

  void clear() {
    state = const DocState();
  }
}
