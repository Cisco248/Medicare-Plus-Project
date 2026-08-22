import 'package:freezed_annotation/freezed_annotation.dart';

part 'doc.state.freezed.dart';
part 'doc.state.g.dart';

enum DocModel {
  diabetes('Diabetes'),
  hypertension('Hypertension'),
  bloodPressure('Blood Pressure');

  const DocModel(this.label);

  final String label;
}

enum DocPhase { idle, loading, success, empty, error }

@Freezed(copyWith: true, fromJson: true, toJson: true, toStringOverride: true)
abstract class DocState with _$DocState {
  const DocState._();

  const factory DocState({
    @Default(DocPhase.idle) DocPhase phase,
    @Default(null) DocModel? model,
    @Default(null) String? prediction,
    @Default(null) String? explanation,
    @Default(null) String? errorMessage,
  }) = _DocState;

  static DocState fromResponse(dynamic data, {required DocModel model}) {
    if (data == null) {
      return DocState(
        phase: DocPhase.empty,
        model: model,
        errorMessage: 'No assessment result was returned.',
      );
    }
    if (data is String) {
      final text = data.trim();
      if (text.isEmpty) {
        return DocState(phase: DocPhase.empty, model: model);
      }
      return DocState(phase: DocPhase.success, model: model, explanation: text);
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
        return DocState(
          phase: detail == null ? DocPhase.empty : DocPhase.error,
          model: model,
          errorMessage: detail == null
              ? 'The assessment response did not contain a result.'
              : _friendlyDetail(detail),
        );
      }
      return DocState(
        phase: DocPhase.success,
        model: model,
        prediction: prediction,
        explanation: explanation,
      );
    }
    return DocState(
      phase: DocPhase.success,
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
