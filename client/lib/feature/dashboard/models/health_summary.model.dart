import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_summary.model.freezed.dart';
part 'health_summary.model.g.dart';

@freezed
abstract class SummaryPeriod with _$SummaryPeriod {
  const factory SummaryPeriod({
    required DateTime start,
    required DateTime end,
    String? timezoneOffset,
  }) = _SummaryPeriod;

  factory SummaryPeriod.fromJson(Map<String, Object?> json) =>
      _$SummaryPeriodFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$SummaryPeriodToJson(this as _SummaryPeriod);
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

  @override
  Map<String, dynamic> toJson() =>
      _$HealthSummaryRequestToJson(this as _HealthSummaryRequest);

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

/// RAG ``POST /api/knowledge`` body. Missing measurements are omitted.
Map<String, dynamic> knowledgeSummaryJson(
  HealthSummaryRequest request, {
  PatientProfile? user,
  String? question,
}) {
  final activity = request.activities;
  final heightCm = user?.heightCm ??
      (activity.heightMeters == null ? null : activity.heightMeters! * 100);
  final weightKg = activity.weightKilograms ?? user?.weightKg;
  return {
    if (question != null && question.trim().isNotEmpty) 'question': question,
    if (request.userId != null && request.userId!.isNotEmpty)
      'user_id': request.userId,
    'period': {
      'start': request.period.start.toUtc().toIso8601String(),
      'end': request.period.end.toUtc().toIso8601String(),
      if (request.period.timezoneOffset != null)
        'timezone_offset': request.period.timezoneOffset,
    },
    'activities': activity.toKnowledgeJson(),
    if (user?.age != null) 'age': user!.age,
    if (user?.gender != null && user!.gender!.trim().isNotEmpty)
      'gender': user.gender!.trim().toLowerCase(),
    if (heightCm != null && heightCm > 0) 'height_cm': heightCm,
    if (weightKg != null && weightKg > 0) 'weight_kg': weightKg,
  };
}

String _formatOffset(Duration offset) {
  final sign = offset.isNegative ? '-' : '+';
  final total = offset.abs();
  final hours = total.inHours.toString().padLeft(2, '0');
  final minutes = (total.inMinutes % 60).toString().padLeft(2, '0');
  return '$sign$hours:$minutes';
}

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

  @override
  Map<String, dynamic> toJson() =>
      _$HealthSummaryResponseToJson(this as _HealthSummaryResponse);
}
