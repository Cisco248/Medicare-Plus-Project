import 'package:client/feature/pharmacy/models/cart.model.dart';
import 'package:client/feature/pharmacy/models/order.model.dart';
import 'package:client/feature/pharmacy/notifiers/order.notifier.dart';
import 'package:client/feature/pharmacy/page/order_confirmation.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoPaymentPage extends ConsumerStatefulWidget {
  const DemoPaymentPage({super.key, required this.cart, required this.address});

  final CartState cart;
  final DeliveryAddress address;

  @override
  ConsumerState<DemoPaymentPage> createState() => _DemoPaymentPageState();
}

class _DemoPaymentPageState extends ConsumerState<DemoPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _name = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _number.dispose();
    _name.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo payment', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'This is a DEMO payment. Do not enter a real card. No payment gateway is used and card details are not stored.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              Text('Amount due: ${formatLkr(widget.cart.total)}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _number,
                decoration: const InputDecoration(labelText: 'Demo card number', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.replaceAll(' ', '').length < 12
                    ? 'Enter a demo card number (12+ digits).'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name on card', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiry,
                      decoration: const InputDecoration(labelText: 'MM/YY', border: OutlineInputBorder()),
                      validator: (value) => value == null || !value.contains('/') ? 'Use MM/YY' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvv,
                      decoration: const InputDecoration(labelText: 'CVV', border: OutlineInputBorder()),
                      obscureText: true,
                      validator: (value) => value == null || value.length < 3 ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: colorScheme.error)),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _pay,
                child: Text(_busy ? 'Processing demo payment...' : 'Pay (demo)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pay() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final digits = _number.text.replaceAll(RegExp(r'\D'), '');
    final failed = digits.startsWith('0000') || digits.endsWith('0000');
    final status = failed ? PaymentStatus.failed : PaymentStatus.successful;
    final order = await ref.read(orderProvider.notifier).placeOrder(
      cart: widget.cart,
      address: widget.address,
      method: PaymentMethod.demoCard,
      paymentStatus: status,
    );
    if (!mounted) return;
    if (failed) {
      setState(() {
        _busy = false;
        _error = 'Demo payment failed. Try another demo number, or avoid cards starting/ending with 0000.';
      });
      return;
    }
    _number.clear();
    _cvv.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OrderConfirmationPage(order: order)),
    );
  }
}
