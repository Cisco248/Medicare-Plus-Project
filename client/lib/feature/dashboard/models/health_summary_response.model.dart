// @JsonSerializable on freezed factory constructors is the documented way to
// configure json_serializable for freezed classes.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_summary_response.model.freezed.dart';
part 'health_summary_response.model.g.dart';

/// Strongly typed response of the RAG health-summary endpoint.
///
/// The [summary] is an AI-generated informational text grounded in the
/// submitted health data — it is not a medical diagnosis, which the
/// [disclaimer] makes explicit to the user.
@freezed
abstract class HealthSummaryResponse with _$HealthSummaryResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HealthSummaryResponse({
    required String summary,
    @Default(<String>[]) List<String> recommendations,
    String? disclaimer,
    DateTime? generatedAt,
  }) = _HealthSummaryResponse;

  factory HealthSummaryResponse.fromJson(Map<String, Object?> json) =>
      _$HealthSummaryResponseFromJson(json);
}
