import 'package:client/feature/e_doc/models/diabetes.model.dart';
import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/utils/diabetes_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses 120/80 blood pressure', () {
    final bp = parseBloodPressure('120/80');
    expect(bp?.systolic, 120);
    expect(bp?.diastolic, 80);
  });

  test('diabetes payload uses snake_case split blood pressure', () {
    final json = diabetesToApiJson(
      const DiabetesModel(
        age: 45,
        gender: 'male',
        pulseRate: 78,
        bpReading: '120/80',
        glucose: 110,
        bmi: 24.5,
        familyDiabetes: 'Yes',
        hypertensive: 'Yes',
      ),
    );
    expect(json['pulse_rate'], 78);
    expect(json['systolic_bp'], 120);
    expect(json['diastolic_bp'], 80);
    expect(json.containsKey('bpReading'), isFalse);
    expect(json.containsKey('pulseRate'), isFalse);
  });

  test('e-doc maps diagnosis and recommendations from diabetes response', () {
    final state = DocState.fromResponse({
      'prediction': 'Non-Diabetic / Low Risk',
      'diagnosis': 'Non-Diabetic / Low Risk',
      'recommendations': {
        'answer': 'Keep walking and follow up with your doctor.',
      },
    }, model: DocModel.diabetes);
    expect(state.phase, DocPhase.success);
    expect(state.prediction, 'Non-Diabetic / Low Risk');
    expect(state.explanation, contains('Keep walking'));
  });
}
