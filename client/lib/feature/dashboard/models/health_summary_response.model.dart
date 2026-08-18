import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_summary_response.model.freezed.dart';
part 'health_summary_response.model.g.dart';

@freezed
abstract class HealthSummaryResponse with _$HealthSummaryResponse {
  const factory HealthSummaryResponse({
    required String summary,
    @Default(<String>[]) List<String> recommendations,
    String? disclaimer,
    DateTime? generatedAt,
  }) = _HealthSummaryResponse;

  factory HealthSummaryResponse.fromJson(Map<String, Object?> json) =>
      _$HealthSummaryResponseFromJson(json);
}
