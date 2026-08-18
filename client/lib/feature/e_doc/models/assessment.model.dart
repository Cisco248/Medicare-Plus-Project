enum EDocPredictionModel {
  diabetes('Diabetes'),
  hypertension('Hypertension'),
  bloodPressure('Blood Pressure');

  const EDocPredictionModel(this.label);

  final String label;
}

enum EDocAssessmentPhase { idle, loading, success, empty, error }

class EDocAssessmentState {
  const EDocAssessmentState({
    this.phase = EDocAssessmentPhase.idle,
    this.model,
    this.prediction,
    this.explanation,
    this.errorMessage,
  });

  final EDocAssessmentPhase phase;
  final EDocPredictionModel? model;
  final String? prediction;
  final String? explanation;
  final String? errorMessage;

  bool get hasResult =>
      (prediction != null && prediction!.trim().isNotEmpty) ||
      (explanation != null && explanation!.trim().isNotEmpty);

  EDocAssessmentState copyWith({
    EDocAssessmentPhase? phase,
    EDocPredictionModel? model,
    String? prediction,
    String? explanation,
    String? errorMessage,
  }) {
    return EDocAssessmentState(
      phase: phase ?? this.phase,
      model: model ?? this.model,
      prediction: prediction,
      explanation: explanation,
      errorMessage: errorMessage,
    );
  }

  static EDocAssessmentState fromResponse(
    dynamic data, {
    required EDocPredictionModel model,
  }) {
    if (data == null) {
      return EDocAssessmentState(
        phase: EDocAssessmentPhase.empty,
        model: model,
        errorMessage: 'No assessment result was returned.',
      );
    }
    if (data is String) {
      final text = data.trim();
      if (text.isEmpty) {
        return EDocAssessmentState(
          phase: EDocAssessmentPhase.empty,
          model: model,
        );
      }
      return EDocAssessmentState(
        phase: EDocAssessmentPhase.success,
        model: model,
        explanation: text,
      );
    }
    if (data is Map) {
      final map = Map<String, Object?>.from(data);
      final prediction = _stringOf(
        map['prediction'] ?? map['status'] ?? map['label'],
      );
      final explanation = _stringOf(
        map['answer'] ??
            map['explanation'] ??
            map['summary'] ??
            map['message'] ??
            map['body'],
      );
      if ((prediction == null || prediction.isEmpty) &&
          (explanation == null || explanation.isEmpty)) {
        final detail = map['detail'];
        return EDocAssessmentState(
          phase: detail == null
              ? EDocAssessmentPhase.empty
              : EDocAssessmentPhase.error,
          model: model,
          errorMessage: detail == null
              ? 'The assessment response did not contain a result.'
              : _friendlyDetail(detail),
        );
      }
      return EDocAssessmentState(
        phase: EDocAssessmentPhase.success,
        model: model,
        prediction: prediction,
        explanation: explanation,
      );
    }
    return EDocAssessmentState(
      phase: EDocAssessmentPhase.success,
      model: model,
      explanation: data.toString(),
    );
  }

  static String? _stringOf(Object? value) {
    if (value == null) return null;
    if (value is String) {
      final text = value.trim();
      return text.isEmpty ? null : text;
    }
    if (value is Map || value is List) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String _friendlyDetail(Object? detail) {
    if (detail is String) {
      final text = detail.trim();
      if (text.isNotEmpty) return text;
    }
    return 'The assessment service could not generate an explanation. Please try again later.';
  }
}
