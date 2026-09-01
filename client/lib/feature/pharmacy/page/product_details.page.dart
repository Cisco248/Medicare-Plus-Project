import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/pharmacy.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/prescription.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/wishlist.notifier.dart';
import 'package:client/feature/pharmacy/page/cart.page.dart';
import 'package:client/feature/pharmacy/page/prescription_verification.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final PharmacyProduct product;

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  int _quantity = 1;

  PharmacyProduct get product => widget.product;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(recentProductsProvider.notifier).view(product.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final wished =
        ref.watch(wishlistProvider).value?.contains(product.id) ?? false;
    final rx = ref.watch(prescriptionProvider).value![product.id];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(wishlistProvider.notifier).toggle(product.id),
            icon: Icon(
              wished ? Icons.favorite : Icons.favorite_border,
              color: wished ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                product.imgPath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 180,
                  child: Center(
                    child: Icon(Icons.medical_services_outlined, size: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              product.brand,
              style: TextStyle(
                fontFamily: 'Inter',
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.category.label,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  formatLkr(product.discountedPrice),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 8),
                  Text(
                    formatLkr(product.price),
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${(product.discount * 100).round()}% off'),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.inStock
                  ? 'Available (${product.stockCount} in stock)'
                  : 'Currently unavailable',
            ),
            if (product.prescriptionRequired) ...[
              const SizedBox(height: 8),
              Text(
                'Prescription required • ${rx?.status!.label ?? 'Not Submitted'}',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                height: 1.4,
              ),
            ),
            if (product.usage.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Usage',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                product.usage,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
              ),
            ],
            if (product.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Important',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                product.warnings,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: product.inStock ? () => _add(buyNow: false) : null,
              child: const Text('Add to cart'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: product.inStock ? () => _add(buyNow: true) : null,
              child: const Text('Buy now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _add({required bool buyNow}) async {
    if (product.prescriptionRequired) {
      final approved =
          ref.read(prescriptionProvider).value![product.id]?.canPurchase ==
          true;
      if (!approved) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PrescriptionVerificationPage(product: product),
          ),
        );
        return;
      }
    }
    final error = await ref
        .read(cartProvider.notifier)
        .add(product, quantity: _quantity);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    if (buyNow) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CartPage()));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
    }
  }
}
