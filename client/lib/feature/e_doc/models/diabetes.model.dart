// @JsonSerializable on freezed factory constructors is the documented way to
// configure json_serializable for freezed classes.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'diabetes.model.freezed.dart';
part 'diabetes.model.g.dart';

/// Request body for `POST /api-base/diabetes`.
@freezed
abstract class DiabetesModel with _$DiabetesModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
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
