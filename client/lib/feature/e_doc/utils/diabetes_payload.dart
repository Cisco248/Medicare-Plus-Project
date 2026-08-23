import 'package:client/feature/e_doc/models/diabetes.model.dart';

final _bpReading = RegExp(r'^\s*(\d+(?:\.\d+)?)\s*[/\-]\s*(\d+(?:\.\d+)?)\s*$');

({double systolic, double diastolic})? parseBloodPressure(String raw) {
  final match = _bpReading.firstMatch(raw.trim());
  if (match == null) return null;
  return (
    systolic: double.parse(match.group(1)!),
    diastolic: double.parse(match.group(2)!),
  );
}

Map<String, dynamic> diabetesToApiJson(DiabetesModel model) {
  final bp = parseBloodPressure(model.bpReading);
  if (bp == null) {
    throw const FormatException('Blood pressure must look like 120/80');
  }
  return {
    'age': model.age,
    'gender': model.gender,
    'pulse_rate': model.pulseRate,
    'systolic_bp': bp.systolic,
    'diastolic_bp': bp.diastolic,
    'glucose': model.glucose,
    'bmi': model.bmi,
    'family_diabetes': model.familyDiabetes,
    'hypertensive': model.hypertensive,
  };
}
