import 'package:app/core/components/card.dart';
import 'package:flutter/material.dart';

class PharmacyCard extends StatefulWidget {
  const PharmacyCard({super.key});

  @override
  State<PharmacyCard> createState() => _PharmacyCardState();
}

class _PharmacyCardState extends State<PharmacyCard> {
  @override
  Widget build(BuildContext context) {
    return ZintraCard(
      child: Column(
        children: [
          Image.asset(
            'assets/images/panadol.png',
            scale: 1,
            width: 100,
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [Text('Title: Medicine Name'), Text('Category: Tablet')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [Text('Dosage: 10mg'), Text('Price: LKR 200')],
          ),
        ],
      ),
    );
  }
}
