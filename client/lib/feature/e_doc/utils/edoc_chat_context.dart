import 'package:client/feature/dashboard/models/clinical_snapshot.model.dart';
import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/heart_disease.model.dart';
import 'package:client/feature/e_doc/models/hypertension.model.dart';

String diabetesEdocContext(DiabetesModel model, DocState result) {
  return [
    'Latest e-doc screening: diabetes prediction model.',
    if (result.prediction != null && result.prediction!.isNotEmpty)
      'Predicted status: ${result.prediction}.',
    'Age: ${model.age}.',
    'Gender: ${model.gender}.',
    'Pulse rate: ${model.pulseRate} bpm.',
    'Blood pressure: ${model.bpReading} mmHg.',
    'Glucose: ${model.glucose} mmol/L.',
    'BMI: ${model.bmi}.',
    'Family history of diabetes: ${model.familyDiabetes}.',
    'Existing hypertension: ${model.hypertensive}.',
  ].join(' ');
}

String hypertensionEdocContext(HypertensionModel model, DocState result) {
  return [
    'Latest e-doc screening: hypertension prediction model.',
    if (result.prediction != null && result.prediction!.isNotEmpty)
      'Predicted status: ${result.prediction}.',
    'Age: ${model.age}.',
    'Gender: ${model.gender}.',
    'Height: ${model.height} cm.',
    'Weight: ${model.weight} kg.',
    'HbA1c: ${model.hba1c}%.',
    'Cholesterol: ${model.cholesterolMgdl} mg/dL.',
    'Diabetes status: ${_diabetesOrdinalLabel(model.diabetesOrdinal)}.',
  ].join(' ');
}

String heartDiseaseEdocContext(HeartDiseaseModel model, DocState result) {
  return [
    'Latest e-doc screening: heart-disease prediction model.',
    if (result.prediction != null && result.prediction!.isNotEmpty)
      'Predicted status: ${result.prediction}.',
    'Age category: ${model.ageCategory}.',
    'Sex: ${model.sex}.',
    'BMI: ${model.bmi}.',
    'General health: ${model.genHealth}.',
    'Diabetes status: ${model.diabetic}.',
    'Smoking: ${model.smoking}.',
    'Previous stroke: ${model.stroke}.',
    'Difficulty walking: ${model.diffWalking}.',
    'Poor physical-health days in the last 30 days: ${model.physicalHealth}.',
  ].join(' ');
}

String _diabetesOrdinalLabel(DiabetesOrdinal value) {
  return switch (value) {
    DiabetesOrdinal.normal => 'normal',
    DiabetesOrdinal.preDiabetic => 'pre-diabetic',
    DiabetesOrdinal.diabetic => 'diabetic',
  };
}

String snapshotChatContext(ClinicalSnapshot snapshot) {
  final parts = <String>['Recorded health profile values:'];
  if (snapshot.age.isAvailable) {
    parts.add('Age: ${snapshot.age.value}.');
  }
  if (snapshot.gender.isAvailable) {
    parts.add('Gender: ${snapshot.gender.value}.');
  }
  if (snapshot.heightCm.isAvailable) {
    parts.add('Height: ${snapshot.heightCm.value} cm.');
  }
  if (snapshot.weightKg.isAvailable) {
    parts.add('Weight: ${snapshot.weightKg.value} kg.');
  }
  if (snapshot.bmi.isAvailable) {
    parts.add('BMI: ${snapshot.bmi.value!.toStringAsFixed(1)}.');
  }
  if (snapshot.bloodPressureReading.isAvailable) {
    parts.add('Blood pressure: ${snapshot.bloodPressureReading.value} mmHg.');
  }
  if (snapshot.glucose.isAvailable) {
    parts.add('Glucose: ${snapshot.glucose.value} mmol/L.');
  }
  if (snapshot.pulseRate.isAvailable) {
    parts.add('Pulse rate: ${snapshot.pulseRate.value!.toStringAsFixed(0)} bpm.');
  }
  if (parts.length == 1) {
    return '';
  }
  return parts.join(' ');
}

String combineChatContext({
  required String edocContext,
  required String snapshotContext,
}) {
  return [edocContext, snapshotContext]
      .where((item) => item.trim().isNotEmpty)
      .join('\n');
}
