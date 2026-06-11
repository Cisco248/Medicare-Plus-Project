import 'package:app/presentation/pharmacy/components/card.dart';
import 'package:flutter/material.dart';

class EPharmacy extends StatelessWidget {
  const EPharmacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: [SearchBar(), PharmacyCard()]));
  }
}
