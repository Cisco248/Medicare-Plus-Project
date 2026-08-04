import 'package:client/feature/dashboard/page/dashboard.dart';
import 'package:client/feature/pharmacy/page/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageStack extends ConsumerWidget {
  final int selectedIndex;
  const PageStack({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: const [
              Dashboard(),
              Center(child: Text('Profile')),
              Center(child: Text('Profile')),
              EPharmacy(),
            ],
          ),
        ],
      ),
    );
  }
}
