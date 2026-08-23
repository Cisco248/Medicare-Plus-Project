import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/dashboard/models/server_health.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PatientProfile deserializes backend profile fields', () {
    final profile = PatientProfile.fromJson({
      'id': 'u1',
      'name': 'Ada',
      'email': 'ada@example.com',
      'date_of_birth': '1960-01-01',
      'age': 66,
      'height_cm': 170.0,
      'weight_kg': 80.0,
      'conditions': [
        {'code': 'hypertension', 'label': 'Hypertension'},
      ],
    });
    expect(profile.age, 66);
    expect(profile.heightCm, 170);
    expect(profile.conditions.single.code, 'hypertension');
  });

  test('ServerDailySummary keeps missing metrics as null', () {
    final summary = ServerDailySummary.fromJson({
      'date': '2026-08-23',
      'steps': 1200,
      'anomalies': ['Low recorded step count'],
    });
    expect(summary.steps, 1200);
    expect(summary.averageHeartRate, isNull);
    expect(summary.anomalies, isNotEmpty);
  });

  test('ServerPrediction requires model version metadata', () {
    final prediction = ServerPrediction.fromJson({
      'id': 'p1',
      'prediction': 'Potential moderate risk indicators are present.',
      'risk_level': 'moderate',
      'model_name': 'medicare-plus-risk-rules',
      'model_version': '1.0.0',
      'generated_at': '2026-08-23T00:00:00',
      'evidence': [
        {'statement': 'Existing recorded condition: hypertension'},
      ],
    });
    expect(prediction.modelVersion, '1.0.0');
    expect(prediction.evidence, isNotEmpty);
  });
}
