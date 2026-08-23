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
    final height = user.heightCm ??
        (activity.heightMeters == null ? null : activity.heightMeters! * 100);
    final weight = activity.weightKilograms ?? user.weightKg;
    final heart = activity.heartRate?.averageBpm ?? activity.heartRate?.restingBpm;
    final gender = user.gender?.trim().toLowerCase();
    final genderText = switch (gender) {
      'male' => 'Male',
      'female' => 'Female',
      null || '' => 'N/A',
      _ => user.gender!.trim(),
    };
    final pressure = activity.bloodPressure;
    final pressureText = pressure == null
        ? 'N/A'
        : '${pressure.systolicMmHg.toStringAsFixed(0)} mmHg / ${pressure.diastolicMmHg.toStringAsFixed(0)} mmHg';

    return '''
Generate a health summary for the following patient data in the following format:

Context:
You are a health assistant that generates a health summary for a patient based on their activity data.
You are given the patient's age, gender, height, weight, blood pressure, blood sugar, heart rate, sleep, steps, and calories.
You are also given the patient's activity data.
You are to generate a health summary for the patient based on the activity data.
The health summary should be in the following format:

Output Format:
- Health Summary:
- Age: ${_na(user.age, ' years')}
- Gender: $genderText
- Height: ${_na(height, ' cm')}
- Weight: ${_na(weight, ' kg')}
- Blood Pressure: $pressureText
- Blood Sugar: ${_na(activity.bloodGlucoseMmolPerLiter, ' mmol/L')}
- Heart Rate: ${_na(heart, ' bpm')}
- Sleep: ${_na(activity.sleep?.totalMinutes, ' minutes')}
- Steps: ${_na(activity.steps, ' steps')}
- Calories: ${_na(activity.totalCalories, ' calories')}
- Distance: ${_na(activity.distanceMeters, ' meters')}
Today's Date: ${DateTime.now().toLocal()}

Instructions:
- Generate a health summary for the patient based on the activity data.
- Patient predict the current health status of the patient based on the activity data.
- Patient predict the current health trend of the patient based on the activity data.
- Patient predict the current health risk of the patient based on the activity data.
- Patient predict the current health recommendations for the patient based on the activity data.
- Patient predict the current health insights for the patient based on the activity data.
- Use only the recorded values above. If a field is N/A, keep it N/A. Do not invent measurements.
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
