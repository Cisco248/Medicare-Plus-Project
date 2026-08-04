import 'package:client/feature/pharmacy/models/medicine.model.dart';
import 'package:client/feature/pharmacy/viewmodels/pharmacy.notifier.dart';
import 'package:client/feature/pharmacy/widgets/card.dart';
import 'package:client/feature/pharmacy/widgets/search.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EPharmacy extends ConsumerWidget {
  const EPharmacy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(pharmacyProvider);
    return SizedBox(
      child: Column(
        children: [
          SearchWidget(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 6,
              padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
              itemBuilder: (context, index) {
                return PharmacyCard(
                  medicine: MedicineModel(
                    medicineName: 'Panadol Local',
                    category: MedicineCategory.tablet,
                    dosage: 10,
                    price: 200.0,
                    imgPath: 'assets/images/panadol.png',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
