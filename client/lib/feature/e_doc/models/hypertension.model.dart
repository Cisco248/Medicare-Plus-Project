// @JsonSerializable on freezed factory constructors is the documented way to
// configure json_serializable for freezed classes.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hypertension.model.freezed.dart';
part 'hypertension.model.g.dart';

enum DiabetesOrdinal {
  @JsonValue('normal')
  normal,
  @JsonValue('pre-diabetic')
  preDiabetic,
  @JsonValue('diabetic')
  diabetic,
}

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other,
}

/// Request body for `POST /api-base/hypertension`.
@freezed
abstract class HypertensionModel with _$HypertensionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HypertensionModel({
    required int age,
    required double height,
    required double weight,
    required double hba1c,
    @JsonKey(name: 'cholesterol_mgdl') required double cholesterolMgdl,
    required DiabetesOrdinal diabetesOrdinal,
    required Gender gender,
  }) = _HypertensionModel;

  factory HypertensionModel.fromJson(Map<String, Object?> json) =>
      _$HypertensionModelFromJson(json);
}
