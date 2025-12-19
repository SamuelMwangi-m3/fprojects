import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/wishlist_repository.dart';
import '../auth/auth_service.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _wishlisted = false;
  bool _loadingWish = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initWish();
  }

  Future<void> _initWish() async {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;
    final userId = AuthService().userId;
    if (product == null || userId == null) return;
    final repo = WishlistRepository(Supabase.instance.client);
    final isW = await repo.isWishlisted(product.id, userId);
    if (mounted) setState(() => _wishlisted = isW);
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;
    if (product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    final cart = CartService();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(product.title),
            const SizedBox(width: 8),
            if (product.isVerified)
              const Icon(Icons.verified, color: Colors.blue, size: 18),
          ],
        ),
        actions: [
          IconButton(
            icon: _loadingWish
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(_wishlisted ? Icons.favorite : Icons.favorite_border),
            onPressed: () async {
              final userId = AuthService().userId;
              if (userId == null) return;
              setState(() => _loadingWish = true);
              final repo = WishlistRepository(Supabase.instance.client);
              if (_wishlisted) {
                await repo.remove(product.id, userId);
                if (mounted) setState(() => _wishlisted = false);
              } else {
                await repo.add(product.id, userId);
                if (mounted) setState(() => _wishlisted = true);
              }
              if (mounted) setState(() => _loadingWish = false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(product.imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(product.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.add(product, quantity: 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                    child: const Text('Add 1'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.add(product, quantity: 5);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added 5 to cart')),
                      );
                    },
                    child: const Text('Add 5'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}