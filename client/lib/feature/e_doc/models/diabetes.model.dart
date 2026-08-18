import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diabetes.model.freezed.dart';
part 'diabetes.model.g.dart';

@freezed
sealed class DiabetesModel with _$DiabetesModel {
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

  @override
  Map<String, dynamic> toJson() =>
      _$DiabetesModelToJson(this as _DiabetesModel);
}

@freezed
sealed class DiabetesResultModel with _$DiabetesResultModel {
  const factory DiabetesResultModel({
    required int prediction,
    required double riskProbability,
    required String status,
  }) = _DiabetesResultModel;

  factory DiabetesResultModel.fromJson(Map<String, Object?> json) =>
      _$DiabetesResultModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$DiabetesResultModelToJson(this as _DiabetesResultModel);
}
