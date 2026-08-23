import 'package:client/core/utils/body_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BMI is null when height or weight is missing', () {
    expect(BodyMetrics.bmi(heightCm: 170, weightKg: null), isNull);
    expect(BodyMetrics.bmi(heightCm: null, weightKg: 70), isNull);
    expect(BodyMetrics.bmi(heightCm: 0, weightKg: 70), isNull);
  });

  test('BMI is calculated from height and weight', () {
    final value = BodyMetrics.bmi(heightCm: 170, weightKg: 68);
    expect(value, closeTo(23.5, 0.1));
    expect(BodyMetrics.formatBmi(value), '23.5');
  });

  test('age category stays unknown below 18 and maps known adult ages', () {
    expect(BodyMetrics.ageCategory(null), isNull);
    expect(BodyMetrics.ageCategory(17), isNull);
    expect(BodyMetrics.ageCategory(45), '45-49');
    expect(BodyMetrics.ageCategory(80), '80 or older');
  });
}
