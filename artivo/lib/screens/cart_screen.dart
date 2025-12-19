import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../utils/constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cart = CartService();

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(item.quantity.toString())),
                  title: Text(item.product.title),
                  subtitle: Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() => _cart.decrease(item.product.id));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() => _cart.remove(item.product.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total: \$${_cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: items.isEmpty
                      ? null
                      : () async {
                          await Navigator.of(context).pushNamed(AppRoutes.checkout);
                          setState(() {});
                        },
                  child: const Text('Checkout'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

