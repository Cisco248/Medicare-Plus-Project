import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/pharmacy.notifier.dart';
import 'package:client/feature/pharmacy/page/cart.page.dart';
import 'package:client/feature/pharmacy/page/orders.page.dart';
import 'package:client/feature/pharmacy/page/product_list.page.dart';
import 'package:client/feature/pharmacy/page/wishlist.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:client/feature/pharmacy/widgets/search.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EPharmacy extends ConsumerWidget {
  const EPharmacy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(pharmacyCatalogProvider);
    final query = ref.watch(pharmacyQueryProvider);
    final cartCount = ref.watch(cartProvider).value?.itemCount ?? 0;
    final colorScheme = Theme.of(context).colorScheme;

    return catalog.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(
        child: FilledButton.tonal(
          onPressed: () => ref.read(pharmacyCatalogProvider.notifier).refresh(),
          child: const Text('Retry catalogue'),
        ),
      ),
      data: (products) {
        final visible = query.apply(products);
        final featured = [...products]
          ..sort((a, b) => b.discount.compareTo(a.discount));
        final popular = [...products]
          ..sort((a, b) => b.popularity.compareTo(a.popularity));
        final recommended = products
            .where((product) => !product.prescriptionRequired)
            .take(4)
            .toList();
        final recentIds = ref.watch(recentProductsProvider).value ?? const [];
        final recent = [
          for (final id in recentIds)
            for (final product in products)
              if (product.id == id) product,
        ];

        return Material(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'E-Pharmacy',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Everyday healthcare items. Prescription medicines require verification.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: colorScheme.onPrimaryContainer.withAlpha(
                                  180,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Cart',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        ),
                        icon: Badge(
                          isLabelVisible: cartCount > 0,
                          label: Text('$cartCount'),
                          child: const FaIcon(
                            FontAwesomeIcons.cartShopping,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Orders',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const OrdersPage()),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.boxOpen, size: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SearchWidget(
                onSubmitted: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProductListPage()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  direction: Axis.horizontal,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ActionChip(
                      label: const Text('Wishlist'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const WishlistPage()),
                      ),
                    ),
                    ...ProductCategory.values.map(
                      (category) => ActionChip(
                        label: Text(category.label),
                        onPressed: () {
                          ref
                              .read(pharmacyQueryProvider.notifier)
                              .setCategory(category);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProductListPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (query.search.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Search results',
                  onSeeAll: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProductListPage()),
                  ),
                ),
                ...visible
                    .take(4)
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ProductCard(product: product),
                      ),
                    ),
              ] else ...[
                _SectionHeader(
                  title: 'Featured',
                  onSeeAll: () => _openList(context),
                ),
                ...featured
                    .take(3)
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ProductCard(product: product),
                      ),
                    ),
                _SectionHeader(
                  title: 'Popular',
                  onSeeAll: () {
                    ref
                        .read(pharmacyQueryProvider.notifier)
                        .setSort(ProductSort.popularity);
                    _openList(context);
                  },
                ),
                ...popular
                    .take(3)
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ProductCard(product: product),
                      ),
                    ),
                _SectionHeader(
                  title: 'Recommended',
                  onSeeAll: () => _openList(context),
                ),
                ...recommended.map(
                  (product) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProductCard(product: product),
                  ),
                ),
                if (recent.isNotEmpty) ...[
                  const _SectionHeader(title: 'Recently viewed'),
                  ...recent.map(
                    (product) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ProductCard(product: product, compact: true),
                    ),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  void _openList(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProductListPage()));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: const Text('See all')),
        ],
      ),
    );
  }
}
