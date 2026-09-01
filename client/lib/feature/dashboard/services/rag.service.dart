import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/exceptions/response.exception.dart';
import 'package:client/feature/dashboard/models/health_summary.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:dio/dio.dart';

class RagService {
  RagService({required this._client});

  final Dio _client;

  String generationQuestion(HealthSummaryRequest data, PatientProfile user) {
    final activity = data.activities;
    final gender = user.gender?.trim();
    final genderText = (gender == null || gender.isEmpty)
        ? 'N/A'
        : '${gender[0].toUpperCase()}${gender.substring(1)}';
    final heightCm =
        user.heightCm ??
        (activity.heightMeters == null ? null : activity.heightMeters! * 100);
    final weightKg = activity.weightKilograms ?? user.weightKg;
    final bp = activity.bloodPressure;
    final bpText = bp == null
        ? 'N/A'
        : '${bp.systolicMmHg}/${bp.diastolicMmHg} mmHg';
    final sleep = activity.sleep;

    return '''
Generate a health summary for the following patient data.

Context:
You are a health assistant that generates a health summary for a patient based on their activity data.

Recorded values (input only; do not copy this list into the report):
- Age: ${_na(user.age, ' years')}
- Gender: $genderText
- Height: ${_na(heightCm, ' cm')}
- Weight: ${_na(weightKg, ' kg')}
- Blood Pressure: $bpText
- Blood Sugar: ${_na(activity.bloodGlucoseMmolPerLiter, ' mmol/L')}
- Heart Rate: ${_na(activity.heartRate?.averageBpm, ' bpm')}
- Sleep: ${_na(sleep?.totalMinutes, ' minutes')}
- Steps: ${_na(activity.steps, ' steps')}
- Calories: ${_na(activity.totalCalories ?? activity.activeCalories, ' kcal')}
- Distance: ${_na(activity.distanceMeters, ' m')}
- Today's Date: ${data.period.start.toUtc().toIso8601String()}

Instructions:
- Do not include a Health Summary parameter list in the answer.
- Write Status, Trend, Risk, Recommendations, and Insights only.
- Use only the recorded values above. If a field is N/A, treat it as unavailable. Do not invent measurements.
''';
  }

  String _na(Object? value, String suffix) =>
      value == null ? 'N/A' : '$value$suffix';

  Future<HealthSummaryResponse> generateHealthSummary(
    HealthSummaryRequest request, {
    required PatientProfile user,
    String? token,
  }) async {
    try {
      final response = await _client.post<Object?>(
        '/api/knowledge',
        data: knowledgeSummaryJson(
          request,
          user: user,
          question: generationQuestion(request, user),
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null && token.isNotEmpty) 'X-Auth-Token': token,
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw AppException.fromCode(response);
      }
      return _parse(response.data);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  HealthSummaryResponse _parse(Object? data) {
    if (data is! Map) {
      throw const ValidationException(
        message: 'The summary service returned an unexpected response.',
      );
    }
    final json = Map<String, dynamic>.from(data);
    if (json['generated_at'] != null && json['generatedAt'] == null) {
      json['generatedAt'] = json['generated_at'];
    }
    try {
      return HealthSummaryResponse.fromJson(json);
    } on Object catch (e) {
      throw ValidationException(
        message: 'The summary service returned an unexpected response.',
        details: e,
      );
    }
  }
}
