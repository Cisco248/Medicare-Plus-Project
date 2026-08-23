import 'package:client/core/utils/body_metrics.dart';
import 'package:client/feature/dashboard/models/clinical_snapshot.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';

/// Maps the shared health/profile snapshot onto each e-doc model.
/// Unavailable values stay null. Never substitutes 0.
class ClinicalParameterMapper {
  const ClinicalParameterMapper(this.snapshot);

  final ClinicalSnapshot snapshot;

  DiabetesPrefill diabetes() {
    return DiabetesPrefill(
      age: snapshot.age.value,
      gender: snapshot.gender.value,
      bmi: snapshot.bmi.value,
      bpReading: snapshot.bloodPressureReading.value,
      glucose: snapshot.glucose.value,
      pulseRate: snapshot.pulseRate.value,
      hypertensive: snapshot.hasCondition('hypertension') ? true : null,
      ageSource: snapshot.age.source,
      genderSource: snapshot.gender.source,
      bmiSource: snapshot.bmi.source,
      bpSource: snapshot.bloodPressureReading.source,
      glucoseSource: snapshot.glucose.source,
      pulseSource: snapshot.pulseRate.source,
    );
  }

  HypertensionPrefill hypertension() {
    DiabetesOrdinal? diabetes;
    if (snapshot.hasCondition('diabetes')) {
      diabetes = DiabetesOrdinal.diabetic;
    }
    Gender? gender;
    switch (snapshot.gender.value) {
      case 'male':
        gender = Gender.male;
      case 'female':
        gender = Gender.female;
      case 'other':
        gender = Gender.other;
    }
    return HypertensionPrefill(
      age: snapshot.age.value,
      heightCm: snapshot.heightCm.value,
      weightKg: snapshot.weightKg.value,
      gender: gender,
      diabetes: diabetes,
      ageSource: snapshot.age.source,
      heightSource: snapshot.heightCm.source,
      weightSource: snapshot.weightKg.source,
      genderSource: snapshot.gender.source,
    );
  }

  HeartDiseasePrefill heartDisease() {
    String? diabetic;
    if (snapshot.hasCondition('diabetes')) {
      diabetic = 'Yes';
    }
    return HeartDiseasePrefill(
      ageCategory: BodyMetrics.ageCategory(snapshot.age.value),
      sex: snapshot.gender.value,
      bmi: snapshot.bmi.value,
      diabetic: diabetic,
      smoking: snapshot.hasCondition('smoking') ? 'Yes' : null,
      stroke: snapshot.hasCondition('stroke') ? 'Yes' : null,
      ageSource: snapshot.age.source,
      sexSource: snapshot.gender.source,
      bmiSource: snapshot.bmi.source,
    );
  }
}

class DiabetesPrefill {
  const DiabetesPrefill({
    this.age,
    this.gender,
    this.bmi,
    this.bpReading,
    this.glucose,
    this.pulseRate,
    this.hypertensive,
    this.ageSource = HealthValueSource.unavailable,
    this.genderSource = HealthValueSource.unavailable,
    this.bmiSource = HealthValueSource.unavailable,
    this.bpSource = HealthValueSource.unavailable,
    this.glucoseSource = HealthValueSource.unavailable,
    this.pulseSource = HealthValueSource.unavailable,
  });

  final int? age;
  final String? gender;
  final double? bmi;
  final String? bpReading;
  final double? glucose;
  final double? pulseRate;
  final bool? hypertensive;
  final HealthValueSource ageSource;
  final HealthValueSource genderSource;
  final HealthValueSource bmiSource;
  final HealthValueSource bpSource;
  final HealthValueSource glucoseSource;
  final HealthValueSource pulseSource;
}

class HypertensionPrefill {
  const HypertensionPrefill({
    this.age,
    this.heightCm,
    this.weightKg,
    this.gender,
    this.diabetes,
    this.ageSource = HealthValueSource.unavailable,
    this.heightSource = HealthValueSource.unavailable,
    this.weightSource = HealthValueSource.unavailable,
    this.genderSource = HealthValueSource.unavailable,
  });

  final int? age;
  final double? heightCm;
  final double? weightKg;
  final Gender? gender;
  final DiabetesOrdinal? diabetes;
  final HealthValueSource ageSource;
  final HealthValueSource heightSource;
  final HealthValueSource weightSource;
  final HealthValueSource genderSource;
}

class HeartDiseasePrefill {
  const HeartDiseasePrefill({
    this.ageCategory,
    this.sex,
    this.bmi,
    this.diabetic,
    this.smoking,
    this.stroke,
    this.ageSource = HealthValueSource.unavailable,
    this.sexSource = HealthValueSource.unavailable,
    this.bmiSource = HealthValueSource.unavailable,
  });

  final String? ageCategory;
  final String? sex;
  final double? bmi;
  final String? diabetic;
  final String? smoking;
  final String? stroke;
  final HealthValueSource ageSource;
  final HealthValueSource sexSource;
  final HealthValueSource bmiSource;
}
