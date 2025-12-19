import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/order_repository.dart';
import '../services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _city.dispose();
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = OrderRepository(Supabase.instance.client);
    final cart = CartService();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _city,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _country,
              decoration: const InputDecoration(labelText: 'Country'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            const Text('Payment method (placeholder)'),
            const SizedBox(height: 16),
            const Text('Tax & shipping will be calculated at payment'),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!_form.currentState!.validate()) return;
                final items = cart.items
                    .map((e) => {
                          'product_id': e.product.id,
                          'qty': e.quantity,
                          'unit_price': e.product.price,
                        })
                    .toList();
                final orderPayload = {
                  'status': 'placed',
                  'total': cart.totalPrice,
                  'currency': 'USD',
                  'items': items,
                  'shipping_name': _name.text.trim(),
                  'shipping_address': _address.text.trim(),
                  'shipping_city': _city.text.trim(),
                  'shipping_country': _country.text.trim(),
                };
                await repo.createOrder(orderPayload);
                cart.clear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed')),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Place Order'),
            ),
          ),
        ),
      ),
    );
  }
}


