import 'package:client/feature/pharmacy/models/order.model.dart';
import 'package:client/feature/pharmacy/page/order_details.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key, required this.order});

  final PharmacyOrder order;

  @override
  Widget build(BuildContext context) {
    final success = order.paymentStatus == PaymentStatus.successful;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order confirmation',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              Icon(
                success ? Icons.check_circle_outline : Icons.error_outline,
                size: 56,
                color: success
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                success ? 'Order placed' : 'Payment was not completed',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text('Order ${order.orderId}'),
              Text('Total ${formatLkr(order.total)}'),
              Text(
                'Status: ${order.orderStatus.label} • ${order.paymentStatus.label}',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsPage(order: order),
                  ),
                ),
                child: const Text('View order details'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Back to pharmacy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
