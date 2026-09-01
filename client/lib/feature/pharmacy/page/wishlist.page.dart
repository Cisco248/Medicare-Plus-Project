import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/wishlist.notifier.dart';
import 'package:client/feature/pharmacy/page/prescription_verification.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(wishlistProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: products.isEmpty
            ? const Center(child: Text('No saved products yet.'))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text(formatLkr(product.discountedPrice)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Remove from wishlist',
                            onPressed: () => ref
                                .read(wishlistProvider.notifier)
                                .toggle(product.id),
                            icon: const Icon(Icons.favorite, color: Colors.red),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Add to cart',
                            onPressed: () async {
                              if (product.prescriptionRequired) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PrescriptionVerificationPage(
                                          product: product,
                                        ),
                                  ),
                                );
                                return;
                              }
                              final error = await ref
                                  .read(cartProvider.notifier)
                                  .add(product);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error ?? '${product.name} added to cart',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
