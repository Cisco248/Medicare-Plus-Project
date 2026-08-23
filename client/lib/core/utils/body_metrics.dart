/// Single place for derived body measurements. Never invents missing inputs.
class BodyMetrics {
  static double? bmi({double? heightCm, double? weightKg}) {
    if (heightCm == null || weightKg == null) return null;
    if (heightCm <= 0 || weightKg <= 0) return null;
    final meters = heightCm / 100;
    return weightKg / (meters * meters);
  }

  static const ageCategories = [
    '18-24',
    '25-29',
    '30-34',
    '35-39',
    '40-44',
    '45-49',
    '50-54',
    '55-59',
    '60-64',
    '65-69',
    '70-74',
    '75-79',
    '80 or older',
  ];

  static String? ageCategory(int? age) {
    if (age == null || age < 18) return null;
    if (age >= 80) return '80 or older';
    const bands = <(int, String)>[
      (24, '18-24'),
      (29, '25-29'),
      (34, '30-34'),
      (39, '35-39'),
      (44, '40-44'),
      (49, '45-49'),
      (54, '50-54'),
      (59, '55-59'),
      (64, '60-64'),
      (69, '65-69'),
      (74, '70-74'),
      (79, '75-79'),
    ];
    for (final band in bands) {
      if (age <= band.$1) return band.$2;
    }
    return '80 or older';
  }

  static String? formatBmi(double? value) {
    if (value == null) return null;
    return value.toStringAsFixed(1);
  }
}
