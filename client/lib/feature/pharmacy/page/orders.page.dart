import 'package:client/feature/pharmacy/notifiers/order.notifier.dart';
import 'package:client/feature/pharmacy/page/order_details.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:client/feature/reports/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: orders.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('Unable to load orders.')),
          data: (items) {
            if (items.isEmpty) {
              return const Center(child: Text('No previous orders yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];
                return Card(
                  child: ListTile(
                    title: Text(order.orderId),
                    subtitle: Text(
                      '${order.orderStatus.label} • ${formatDocumentDate(order.createdAt)}\n${formatLkr(order.total)} • ${order.items.length} item(s)',
                    ),
                    isThreeLine: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsPage(order: order),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
