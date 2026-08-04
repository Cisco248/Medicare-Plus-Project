import 'package:client/feature/pharmacy/models/medicine.model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PharmacyCard extends StatefulWidget {
  final MedicineModel medicine;

  const PharmacyCard({super.key, required this.medicine});

  @override
  State<PharmacyCard> createState() => _PharmacyCardState();
}

class _PharmacyCardState extends State<PharmacyCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(180),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              widget.medicine.imgPath,
              scale: 1,
              width: 100,
              height: 100,
            ),
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.medicine.medicineName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              //Text('Category: ${medicine.category.name}'),
              // Text('Dosage: ${medicine.dosage}ml'),
              Text('Price: LKR ${widget.medicine.price}'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapped = !isTapped;
                    });
                  },
                  child: isTapped
                      ? Icon(Icons.favorite, color: Colors.red, size: 16)
                      : Icon(Icons.favorite_border, size: 16),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: FaIcon(FontAwesomeIcons.cartShopping, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
