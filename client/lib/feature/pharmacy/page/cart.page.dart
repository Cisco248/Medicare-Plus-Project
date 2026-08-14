import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/page/checkout.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => ref.read(cartProvider.notifier).clear(),
            child: const Text('Clear'),
          ),
        ],
      ),
      body: SafeArea(
        child: cart.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('Unable to load the cart.')),
          data: (state) {
            if (state.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.cartShopping, color: colorScheme.onSurface.withAlpha(80)),
                    const SizedBox(height: 12),
                    const Text('Your cart is empty'),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text('${formatLkr(item.lineTotal)} • ${item.product.category.label}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => ref.read(cartProvider.notifier).setQuantity(item.product.id, item.quantity - 1),
                                icon: const Icon(Icons.remove),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                onPressed: () => ref.read(cartProvider.notifier).setQuantity(item.product.id, item.quantity + 1),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () => ref.read(cartProvider.notifier).remove(item.product.id),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    children: [
                      _line('Subtotal', formatLkr(state.subtotal)),
                      _line('Discount', '- ${formatLkr(state.discount)}'),
                      _line('Delivery', state.deliveryFee == 0 ? 'Free' : formatLkr(state.deliveryFee)),
                      _line('Total', formatLkr(state.total), bold: true),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CheckoutPage()),
                          ),
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _line(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }
}
