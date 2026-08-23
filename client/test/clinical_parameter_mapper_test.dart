import 'package:client/feature/dashboard/models/activity.model.dart';
import 'package:client/feature/dashboard/models/clinical_snapshot.model.dart';
import 'package:client/feature/dashboard/models/patient_profile.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';
import 'package:client/feature/e_doc/utils/clinical_parameter_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unavailable snapshot does not invent clinical zeros', () {
    const snapshot = ClinicalSnapshot();
    final diabetes = ClinicalParameterMapper(snapshot).diabetes();
    final heart = ClinicalParameterMapper(snapshot).heartDisease();

    expect(diabetes.age, isNull);
    expect(diabetes.bmi, isNull);
    expect(diabetes.glucose, isNull);
    expect(diabetes.hypertensive, isNull);
    expect(heart.ageCategory, isNull);
    expect(heart.smoking, isNull);
    expect(heart.stroke, isNull);
    expect(heart.diabetic, isNull);
    expect(snapshot.bmi.source, HealthValueSource.unavailable);
  });

  test('maps profile, calculated BMI, and recorded conditions only', () {
    final snapshot = ClinicalSnapshot(
      profile: PatientProfile(
        id: 'u1',
        name: 'Ada',
        email: 'ada@example.com',
        age: 52,
        gender: 'female',
        heightCm: 165,
        weightKg: 70,
        conditions: const [
          PatientCondition(code: 'hypertension', label: 'Hypertension'),
          PatientCondition(code: 'diabetes', label: 'Diabetes'),
          PatientCondition(code: 'smoking', label: 'Smoking'),
        ],
      ),
      activity: ActivityModel(
        date: DateTime(2026, 8, 23),
        heartRate: const HeartRateSummary(averageBpm: 76),
        bloodPressure: const BloodPressureSummary(
          systolicMmHg: 128,
          diastolicMmHg: 82,
        ),
      ),
    );

    final diabetes = ClinicalParameterMapper(snapshot).diabetes();
    final hypertension = ClinicalParameterMapper(snapshot).hypertension();
    final heart = ClinicalParameterMapper(snapshot).heartDisease();

    expect(diabetes.age, 52);
    expect(diabetes.gender, 'female');
    expect(diabetes.bmi, closeTo(25.7, 0.1));
    expect(diabetes.bpReading, '128/82');
    expect(diabetes.pulseRate, 76);
    expect(diabetes.hypertensive, isTrue);
    expect(diabetes.ageSource, HealthValueSource.profile);
    expect(diabetes.bmiSource, HealthValueSource.calculated);
    expect(diabetes.bpSource, HealthValueSource.healthConnect);

    expect(hypertension.gender, Gender.female);
    expect(hypertension.diabetes, DiabetesOrdinal.diabetic);
    expect(hypertension.heightCm, 165);

    expect(heart.ageCategory, '50-54');
    expect(heart.sex, 'female');
    expect(heart.diabetic, 'Yes');
    expect(heart.smoking, 'Yes');
    expect(heart.stroke, isNull);
  });

  test(
    'Health Connect height and weight fill snapshot when profile is empty',
    () {
      final snapshot = ClinicalSnapshot(
        activity: ActivityModel(
          date: DateTime(2026, 8, 23),
          heightMeters: 1.8,
          weightKilograms: 81,
        ),
      );

      expect(snapshot.heightCm.value, closeTo(180, 0.01));
      expect(snapshot.heightCm.source, HealthValueSource.healthConnect);
      expect(snapshot.weightKg.source, HealthValueSource.healthConnect);
      expect(snapshot.bmi.value, closeTo(25.0, 0.1));
    },
  );
}
