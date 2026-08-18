import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_summary_request.model.freezed.dart';
part 'health_summary_request.model.g.dart';

@freezed
abstract class SummaryPeriod with _$SummaryPeriod {
  const factory SummaryPeriod({
    required DateTime start,
    required DateTime end,
    String? timezoneOffset,
  }) = _SummaryPeriod;

  factory SummaryPeriod.fromJson(Map<String, Object?> json) =>
      _$SummaryPeriodFromJson(json);
}

@freezed
abstract class HealthSummaryRequest with _$HealthSummaryRequest {
  const factory HealthSummaryRequest({
    String? userId,
    required SummaryPeriod period,
    required ActivityModel activities,
  }) = _HealthSummaryRequest;

  factory HealthSummaryRequest.fromJson(Map<String, Object?> json) =>
      _$HealthSummaryRequestFromJson(json);

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
