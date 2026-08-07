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
    return SizedBox(
      child: Column(
        children: [
          SearchWidget(),
          Expanded(
            child: ref
                .watch(pharmacyProvider)
                .when(
                  data: (data) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
                      itemBuilder: (context, index) {
                        return PharmacyCard(
                          medicine: MedicineModel(
                            medicineName: data[index].medicineName,
                            category: data[index].category,
                            dosage: data[index].dosage,
                            price: data[index].price,
                            imgPath: data[index].imgPath,
                          ),
                        );
                      },
                    );
                  },
                  error: (_, _) => SizedBox(
                    child: Center(child: Text('Error fetching medicines')),
                  ),
                  loading: () => SizedBox(child: CircularProgressIndicator()),
                ),
          ),
        ],
      ),
    );
  }
}
