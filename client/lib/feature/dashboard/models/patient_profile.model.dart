class PatientCondition {
  const PatientCondition({
    required this.code,
    required this.label,
    this.notes,
    this.diagnosedAt,
  });

  final String code;
  final String label;
  final String? notes;
  final String? diagnosedAt;

  factory PatientCondition.fromJson(Map<String, dynamic> json) {
    return PatientCondition(
      code: json['code'] as String? ?? 'other',
      label: json['label'] as String? ?? '',
      notes: json['notes'] as String?,
      diagnosedAt:
          json['diagnosed_at'] as String? ?? json['diagnosedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'label': label,
    if (notes != null) 'notes': notes,
    if (diagnosedAt != null) 'diagnosed_at': diagnosedAt,
  };
}

class PatientMedication {
  const PatientMedication({required this.name, this.dosage, this.frequency});

  final String name;
  final String? dosage;
  final String? frequency;

  factory PatientMedication.fromJson(Map<String, dynamic> json) {
    return PatientMedication(
      name: json['name'] as String? ?? '',
      dosage: json['dosage'] as String?,
      frequency: json['frequency'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    if (dosage != null) 'dosage': dosage,
    if (frequency != null) 'frequency': frequency,
  };
}

class PatientProfile {
  const PatientProfile({
    required this.id,
    required this.name,
    required this.email,
    this.mobnum,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.bloodGroup,
    this.allergies,
    this.clinicalHistory,
    this.emergencyContact,
    this.conditions = const [],
    this.medications = const [],
  });

  final String id;
  final String name;
  final String email;
  final String? mobnum;
  final String? dateOfBirth;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? bloodGroup;
  final String? allergies;
  final String? clinicalHistory;
  final String? emergencyContact;
  final List<PatientCondition> conditions;
  final List<PatientMedication> medications;

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobnum: json['mobnum'] as String?,
      dateOfBirth:
          json['date_of_birth'] as String? ?? json['dateOfBirth'] as String?,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      heightCm:
          (json['height_cm'] as num?)?.toDouble() ??
          (json['heightCm'] as num?)?.toDouble(),
      weightKg:
          (json['weight_kg'] as num?)?.toDouble() ??
          (json['weightKg'] as num?)?.toDouble(),
      bloodGroup:
          json['blood_group'] as String? ?? json['bloodGroup'] as String?,
      allergies: json['allergies'] as String?,
      clinicalHistory:
          json['clinical_history'] as String? ??
          json['clinicalHistory'] as String?,
      emergencyContact:
          json['emergency_contact'] as String? ??
          json['emergencyContact'] as String?,
      conditions: [
        for (final item in json['conditions'] as List? ?? const [])
          PatientCondition.fromJson(Map<String, dynamic>.from(item as Map)),
      ],
      medications: [
        for (final item in json['medications'] as List? ?? const [])
          PatientMedication.fromJson(Map<String, dynamic>.from(item as Map)),
      ],
    );
  }
}
