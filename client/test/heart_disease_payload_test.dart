import 'package:client/feature/e_doc/models/doc.state.dart';
import 'package:client/feature/e_doc/models/heart_disease.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('heart-disease payload matches the notebook feature names', () {
    final json = const HeartDiseaseModel(
      ageCategory: '65-69',
      sex: 'male',
      bmi: 29.4,
      genHealth: 'Fair',
      diabetic: 'Yes',
      smoking: 'Yes',
      stroke: 'No',
      diffWalking: 'Yes',
      physicalHealth: 8,
    ).toApiJson();

    expect(json['age_category'], '65-69');
    expect(json['gen_health'], 'Fair');
    expect(json['diff_walking'], 'Yes');
    expect(json['physical_health'], 8);
    expect(json.containsKey('ageCategory'), isFalse);
  });

  test('e-doc maps heart-disease diagnosis from the API response', () {
    final state = DocState.fromResponse({
      'prediction': 'High heart-disease risk',
      'diagnosis': 'High heart-disease risk',
      'confidence': 0.72,
      'recommendations': {
        'answer': 'See a clinician and review blood pressure.',
      },
    }, model: DocModel.heartDisease);
    expect(state.phase, DocPhase.success);
    expect(state.prediction, 'High heart-disease risk');
    expect(state.explanation, contains('blood pressure'));
  });
}
