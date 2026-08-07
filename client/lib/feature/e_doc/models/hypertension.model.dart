import 'package:freezed_annotation/freezed_annotation.dart';

part "hypertension_model.freezed.dart";

enum DiabetesOrdinal { normal, preDiabetes, diabetes }

enum Gender { male, female, other }

@freezed
sealed class HypertensionModel with _$HypertensionModel {
  const factory HypertensionModel({
    required int age,
    required double weight,
    required double cholesterolUnit,
    required DiabetesOrdinal diabetesOrdinal,
    required Gender gender,
  }) = _HypertensionModel;
}
