import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/e_doc/models/assessment.model.dart';
import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/repository/diabetes.repository.dart';
import 'package:client/feature/e_doc/repository/hypertension.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assessment.notifier.g.dart';

@Riverpod(keepAlive: true)
class EDocAssessmentNotifier extends _$EDocAssessmentNotifier {
  @override
  EDocAssessmentState build() => const EDocAssessmentState();

  Future<void> submitHypertension(HypertensionModel data) async {
    state = EDocAssessmentState(
      phase: EDocAssessmentPhase.loading,
      model: EDocPredictionModel.hypertension,
    );
    try {
      state = await ref.read(hypertensionRepositoryProvider).sendData(data);
    } on AppException catch (e) {
      state = EDocAssessmentState(
        phase: EDocAssessmentPhase.error,
        model: EDocPredictionModel.hypertension,
        errorMessage: e.message,
      );
    } catch (_) {
      state = const EDocAssessmentState(
        phase: EDocAssessmentPhase.error,
        model: EDocPredictionModel.hypertension,
        errorMessage: 'Unable to generate the hypertension assessment.',
      );
    }
  }

  Future<void> submitDiabetes(DiabetesModel data) async {
    state = EDocAssessmentState(
      phase: EDocAssessmentPhase.loading,
      model: EDocPredictionModel.diabetes,
    );
    try {
      state = await ref.read(diabetesRepositoryProvider).predict(data);
    } on AppException catch (e) {
      state = EDocAssessmentState(
        phase: EDocAssessmentPhase.error,
        model: EDocPredictionModel.diabetes,
        errorMessage: e.message,
      );
    } catch (_) {
      state = const EDocAssessmentState(
        phase: EDocAssessmentPhase.error,
        model: EDocPredictionModel.diabetes,
        errorMessage: 'Unable to generate the diabetes assessment.',
      );
    }
  }

  void markUnavailable(EDocPredictionModel model) {
    state = EDocAssessmentState(
      phase: EDocAssessmentPhase.empty,
      model: model,
      errorMessage:
          'This prediction model is not available on the server yet.',
    );
  }

  void clear() {
    state = const EDocAssessmentState();
  }
}
