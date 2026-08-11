enum MedicineCategory { tablet, injection, liquid }

class MedicineModel {
  final String medicineName;
  final MedicineCategory category;
  final int dosage;
  final double price;
  final String imgPath;

  MedicineModel({
    required this.medicineName,
    required this.category,
    required this.dosage,
    required this.price,
    required this.imgPath,
  });
}
