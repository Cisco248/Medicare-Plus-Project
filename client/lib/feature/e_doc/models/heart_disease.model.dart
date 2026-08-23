const heartDiseaseAgeCategories = [
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

const heartDiseaseGenHealth = [
  'Poor',
  'Fair',
  'Good',
  'Very good',
  'Excellent',
];

const heartDiseaseDiabetic = [
  'No',
  'No, borderline diabetes',
  'Yes (during pregnancy)',
  'Yes',
];

class HeartDiseaseModel {
  const HeartDiseaseModel({
    required this.ageCategory,
    required this.sex,
    required this.bmi,
    required this.genHealth,
    required this.diabetic,
    required this.smoking,
    required this.stroke,
    required this.diffWalking,
    required this.physicalHealth,
  });

  final String ageCategory;
  final String sex;
  final double bmi;
  final String genHealth;
  final String diabetic;
  final String smoking;
  final String stroke;
  final String diffWalking;
  final double physicalHealth;

  Map<String, dynamic> toApiJson() => {
    'age_category': ageCategory,
    'sex': sex,
    'bmi': bmi,
    'gen_health': genHealth,
    'diabetic': diabetic,
    'smoking': smoking,
    'stroke': stroke,
    'diff_walking': diffWalking,
    'physical_health': physicalHealth,
  };
}
