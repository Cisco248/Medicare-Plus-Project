import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine.model.freezed.dart';
part 'medicine.model.g.dart';

enum MedicineCategory { tablet, capsule, syrup, injection }

@freezed
sealed class MedicineModel with _$MedicineModel {
  const factory MedicineModel({
    required String medicineName,
    required MedicineCategory category,
    required int dosage,
    required double price,
    required String imgPath,
  }) = _MedicineModel;

  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);
}
