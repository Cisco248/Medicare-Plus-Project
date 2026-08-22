import 'package:client/feature/pharmacy/models/order.model.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:client/feature/reports/widgets/report_card.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final PharmacyOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order details', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          children: [
            Text(order.orderId, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
            Text('Placed ${formatDocumentDate(order.createdAt)}'),
            const SizedBox(height: 8),
            Text('Order status: ${order.orderStatus.label}'),
            Text('Payment: ${order.paymentMethod.label} • ${order.paymentStatus.label}'),
            const SizedBox(height: 16),
            const Text('Items', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            ...order.items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.product.name),
                subtitle: Text('${item.quantity} × ${formatLkr(item.product.discountedPrice)}'),
                trailing: Text(formatLkr(item.lineTotal)),
              ),
            ),
            const Divider(),
            _row('Subtotal', formatLkr(order.subtotal)),
            _row('Discount', formatLkr(order.discount)),
            _row('Delivery fee', formatLkr(order.deliveryFee)),
            _row('Total', formatLkr(order.total), bold: true),
            const SizedBox(height: 16),
            const Text('Delivery address', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            Text(order.deliveryAddress.fullName),
            Text(order.deliveryAddress.phone),
            Text(order.deliveryAddress.formatted),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
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
