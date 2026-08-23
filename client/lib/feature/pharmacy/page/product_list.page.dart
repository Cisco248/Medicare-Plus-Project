import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/notifiers/pharmacy.notifier.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:client/feature/pharmacy/widgets/search.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(pharmacyCatalogProvider);
    final query = ref.watch(pharmacyQueryProvider);
    final notifier = ref.read(pharmacyQueryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: catalog.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              const Center(child: Text('Unable to load products.')),
          data: (products) {
            final visible = query.apply(products);
            return Column(
              children: [
                const SearchWidget(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: query.category == null,
                        onSelected: (_) => notifier.setCategory(null),
                      ),
                      ...ProductCategory.values.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: FilterChip(
                            label: Text(category.label),
                            selected: query.category == category,
                            onSelected: (_) => notifier.setCategory(category),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      DropdownButton<ProductSort>(
                        value: query.sort,
                        onChanged: (value) {
                          if (value != null) notifier.setSort(value);
                        },
                        items: const [
                          DropdownMenuItem(
                            value: ProductSort.popularity,
                            child: Text('Popularity'),
                          ),
                          DropdownMenuItem(
                            value: ProductSort.priceLow,
                            child: Text('Price: low to high'),
                          ),
                          DropdownMenuItem(
                            value: ProductSort.priceHigh,
                            child: Text('Price: high to low'),
                          ),
                          DropdownMenuItem(
                            value: ProductSort.name,
                            child: Text('Name'),
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _priceFilter(context, notifier),
                        child: const Text('Price'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: visible.isEmpty
                      ? const Center(
                          child: Text('No products match these filters.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          itemCount: visible.length,
                          itemBuilder: (context, index) =>
                              ProductCard(product: visible[index]),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _priceFilter(
    BuildContext context,
    PharmacyQueryNotifier notifier,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Any price'),
              onTap: () => Navigator.pop(context, 'any'),
            ),
            ListTile(
              title: const Text('Under LKR 1000'),
              onTap: () => Navigator.pop(context, '1000'),
            ),
            ListTile(
              title: const Text('LKR 1000 - 3000'),
              onTap: () => Navigator.pop(context, '1000-3000'),
            ),
            ListTile(
              title: const Text('Over LKR 3000'),
              onTap: () => Navigator.pop(context, '3000+'),
            ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    switch (selected) {
      case '1000':
        notifier.setPriceRange(0, 1000);
      case '1000-3000':
        notifier.setPriceRange(1000, 3000);
      case '3000+':
        notifier.setPriceRange(3000, null);
      default:
        notifier.setPriceRange(null, null);
    }
  }
}
