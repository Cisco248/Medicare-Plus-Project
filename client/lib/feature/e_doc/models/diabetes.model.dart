import 'package:freezed_annotation/freezed_annotation.dart';

part 'diabetes.model.freezed.dart';
part 'diabetes.model.g.dart';

@freezed
abstract class DiabetesModel with _$DiabetesModel {
  const factory DiabetesModel({
    required int age,
    required String gender,
    required double pulseRate,
    required String bpReading,
    required double glucose,
    required double bmi,
    required String familyDiabetes,
    required String hypertensive,
  }) = _DiabetesModel;

  factory DiabetesModel.fromJson(Map<String, Object?> json) =>
      _$DiabetesModelFromJson(json);
}
