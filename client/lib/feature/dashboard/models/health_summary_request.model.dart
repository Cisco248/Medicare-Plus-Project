// @JsonSerializable on freezed factory constructors is the documented way to
// configure json_serializable for freezed classes.
// ignore_for_file: invalid_annotation_target

import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_summary_request.model.freezed.dart';
part 'health_summary_request.model.g.dart';

/// The date range the health data was collected for.
///
/// [start] and [end] are serialized as UTC ISO-8601 instants;
/// [timezoneOffset] preserves the user's local offset (e.g. `+05:30`) so the
/// backend can reason about local days.
@freezed
abstract class SummaryPeriod with _$SummaryPeriod {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SummaryPeriod({
    required DateTime start,
    required DateTime end,
    String? timezoneOffset,
  }) = _SummaryPeriod;

  factory SummaryPeriod.fromJson(Map<String, Object?> json) =>
      _$SummaryPeriodFromJson(json);
}

/// Request payload for the RAG health-summary endpoint (`POST /knowledge`).
///
/// Contains structured, factual health data only. Missing metrics are sent as
/// `null` and mean "unavailable" — the backend must not treat them as zero.
@freezed
abstract class HealthSummaryRequest with _$HealthSummaryRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory HealthSummaryRequest({
    String? userId,
    required SummaryPeriod period,
    required ActivityModel activities,
  }) = _HealthSummaryRequest;

  factory HealthSummaryRequest.fromJson(Map<String, Object?> json) =>
      _$HealthSummaryRequestFromJson(json);

  /// Builds the request from normalized [activity] data for a local period.
  factory HealthSummaryRequest.fromActivity({
    required ActivityModel activity,
    required DateTime startTime,
    required DateTime endTime,
    String? userId,
  }) {
    return HealthSummaryRequest(
      userId: userId,
      period: SummaryPeriod(
        start: startTime.toUtc(),
        end: endTime.toUtc(),
        timezoneOffset: _formatOffset(startTime.timeZoneOffset),
      ),
      activities: activity,
    );
  }
}

String _formatOffset(Duration offset) {
  final sign = offset.isNegative ? '-' : '+';
  final total = offset.abs();
  final hours = total.inHours.toString().padLeft(2, '0');
  final minutes = (total.inMinutes % 60).toString().padLeft(2, '0');
  return '$sign$hours:$minutes';
}
