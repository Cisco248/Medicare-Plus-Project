import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/pharmacy/models/order.model.dart';
import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/order.notifier.dart';
import 'package:client/feature/pharmacy/page/demo_payment.page.dart';
import 'package:client/feature/pharmacy/page/order_confirmation.page.dart';
import 'package:client/feature/pharmacy/widgets/product_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController();
  PaymentMethod _method = PaymentMethod.cashOnDelivery;
  String _delivery = 'Standard (2-4 days)';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_prefill);
  }

  Future<void> _prefill() async {
    final user = ref.read(authenticationProvider).value?.data;
    final saved = await ref.read(lastAddressProvider.future);
    _name.text = saved?.fullName ?? user?.name ?? '';
    _phone.text = saved?.phone ?? user?.mobnum ?? '';
    _line1.text = saved?.line1 ?? '';
    _line2.text = saved?.line2 ?? '';
    _city.text = saved?.city ?? '';
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _line1.dispose();
    _line2.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider).value;
    if (cart == null || cart.isEmpty) {
      return const Scaffold(body: Center(child: Text('Your cart is empty.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            children: [
              const Text(
                'Delivery address',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Contact number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _line1,
                decoration: const InputDecoration(
                  labelText: 'Address line 1',
                  border: OutlineInputBorder(),
                ),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _line2,
                decoration: const InputDecoration(
                  labelText: 'Address line 2 (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _city,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: _required,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delivery method',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Standard (2-4 days)'),
                    selected: _delivery == 'Standard (2-4 days)',
                    onSelected: (_) =>
                        setState(() => _delivery = 'Standard (2-4 days)'),
                  ),
                  ChoiceChip(
                    label: const Text('Express (1-2 days)'),
                    selected: _delivery == 'Express (1-2 days)',
                    onSelected: (_) =>
                        setState(() => _delivery = 'Express (1-2 days)'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Payment method',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(PaymentMethod.cashOnDelivery.label),
                    selected: _method == PaymentMethod.cashOnDelivery,
                    onSelected: (_) =>
                        setState(() => _method = PaymentMethod.cashOnDelivery),
                  ),
                  ChoiceChip(
                    label: Text(PaymentMethod.demoCard.label),
                    selected: _method == PaymentMethod.demoCard,
                    onSelected: (_) =>
                        setState(() => _method = PaymentMethod.demoCard),
                  ),
                ],
              ),
              if (_method == PaymentMethod.demoCard)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('University demo only. No real card is charged.'),
                ),
              const SizedBox(height: 8),
              _line('Items', '${cart.itemCount}'),
              _line('Subtotal', formatLkr(cart.subtotal)),
              _line('Delivery', formatLkr(cart.deliveryFee)),
              _line('Total', formatLkr(cart.total), bold: true),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _placeOrder,
                child: Text(_busy ? 'Please wait...' : 'Place order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;

  Widget _line(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    final cart = ref.read(cartProvider).value;
    if (cart == null || cart.isEmpty) return;
    final address = DeliveryAddress(
      fullName: _name.text.trim(),
      phone: _phone.text.trim(),
      line1: _line1.text.trim(),
      line2: _line2.text.trim(),
      city: _city.text.trim(),
    );

    if (_method == PaymentMethod.demoCard) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DemoPaymentPage(cart: cart, address: address),
        ),
      );
      return;
    }

    setState(() => _busy = true);
    final order = await ref
        .read(orderProvider.notifier)
        .placeOrder(
          cart: cart,
          address: address,
          method: PaymentMethod.cashOnDelivery,
          paymentStatus: PaymentStatus.successful,
        );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OrderConfirmationPage(order: order)),
    );
  }
}
