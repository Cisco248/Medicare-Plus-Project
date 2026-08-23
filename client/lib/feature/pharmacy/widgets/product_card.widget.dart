import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/wishlist.notifier.dart';
import 'package:client/feature/pharmacy/page/prescription_verification.page.dart';
import 'package:client/feature/pharmacy/page/product_details.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String formatLkr(double value) => 'LKR ${value.toStringAsFixed(0)}';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.compact = false});

  final PharmacyProduct product;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final wished =
        ref.watch(wishlistProvider).value?.contains(product.id) ?? false;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer.withAlpha(180),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                product.imgPath,
                width: compact ? 72 : 96,
                height: compact ? 72 : 96,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => SizedBox(
                  width: compact ? 72 : 96,
                  height: compact ? 72 : 96,
                  child: const Icon(Icons.medical_services_outlined),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      product.category.label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: colorScheme.onSurface.withAlpha(140),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          formatLkr(product.discountedPrice),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            formatLkr(product.price),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: colorScheme.onSurface.withAlpha(120),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.inStock ? 'In stock' : 'Out of stock',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: product.inStock
                            ? Colors.green
                            : colorScheme.error,
                      ),
                    ),
                    if (product.prescriptionRequired)
                      Text(
                        'Prescription required',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () =>
                        ref.read(wishlistProvider.notifier).toggle(product.id),
                    icon: Icon(
                      wished ? Icons.favorite : Icons.favorite_border,
                      color: wished ? Colors.red : colorScheme.onSurface,
                      size: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _addToCart(context, ref),
                    icon: const FaIcon(FontAwesomeIcons.cartPlus, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, WidgetRef ref) async {
    if (product.prescriptionRequired) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PrescriptionVerificationPage(product: product),
        ),
      );
      return;
    }
    final error = await ref.read(cartProvider.notifier).add(product);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? '${product.name} added to cart')),
    );
  }
}
