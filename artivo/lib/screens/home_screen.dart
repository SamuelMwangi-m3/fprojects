import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/product_repository.dart';
import '../services/cart_service.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductRepository _repo = ProductRepository(Supabase.instance.client);
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _repo.listFeatured(limit: 20);
      setState(() {
        _products = items.isEmpty ? _fallbackProducts() : items;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _products = _fallbackProducts();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = CartService().totalItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artivo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.search),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.help),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.of(context).pushNamed('/cart').then((_) => setState(() {})),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _load,
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: PageView(
                children: const [
                  _Banner(imageUrl: 'https://images.unsplash.com/photo-1496483648148-47c686dc86a8'),
                  _Banner(imageUrl: 'https://images.unsplash.com/photo-1504199367641-aba8151af406'),
                  _Banner(imageUrl: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e'),
                ],
              ),
            ),
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  _chip('All'),
                  _chip('Painting'),
                  _chip('Digital'),
                  _chip('Photography'),
                  _chip('Sculpture'),
                  _chip('Abstract'),
                  _chip('Realism'),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _products.length,
                itemBuilder: (ctx, i) {
                  final product = _products[i];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      '/product-detail',
                      arguments: product,
                    ).then((_) => setState(() {})),
                    child: Card(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (product.isVerified)
                                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('\$${product.price.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(label: Text(label)),
    );
  }

  List<Product> _fallbackProducts() {
    return [
      Product(
        id: 'p1',
        title: 'Sunset Canvas',
        description: 'Acrylic on canvas, 24x36 inch.',
        price: 120.0,
        imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
        categories: const ['Painting', 'Abstract'],
        isVerified: true,
      ),
      Product(
        id: 'p2',
        title: 'Abstract Shapes',
        description: 'Digital print, A2 size.',
        price: 45.0,
        imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29',
        categories: const ['Digital'],
      ),
      Product(
        id: 'p3',
        title: 'Minimalist Lines',
        description: 'Ink on paper, framed.',
        price: 80.0,
        imageUrl: 'https://images.unsplash.com/photo-1526318472351-c75fcf070305',
        categories: const ['Drawing'],
      ),
      Product(
        id: 'p4',
        title: 'Ocean Dream',
        description: 'Soothing seascape print.',
        price: 60.0,
        imageUrl: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21',
        categories: const ['Photography'],
      ),
      Product(
        id: 'p5',
        title: 'Forest Light',
        description: 'Nature photography print.',
        price: 55.0,
        imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
        categories: const ['Photography'],
      ),
      Product(
        id: 'p6',
        title: 'City Geometry',
        description: 'Modern abstract cityscape.',
        price: 110.0,
        imageUrl: 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429',
        categories: const ['Abstract'],
        isVerified: true,
      ),
      Product(
        id: 'p7',
        title: 'Golden Field',
        description: 'Warm tone landscape.',
        price: 95.0,
        imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
        categories: const ['Landscape'],
      ),
      Product(
        id: 'p8',
        title: 'Night Sky',
        description: 'Starry night scene.',
        price: 130.0,
        imageUrl: 'https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3',
        categories: const ['Photography'],
      ),
      Product(
        id: 'p9',
        title: 'Color Splash',
        description: 'Bold mixed media.',
        price: 150.0,
        imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa',
        categories: const ['Mixed Media'],
      ),
      Product(
        id: 'p10',
        title: 'Serene Lake',
        description: 'Calm reflections.',
        price: 85.0,
        imageUrl: 'https://images.unsplash.com/photo-1504198453319-5ce911bafcde',
        categories: const ['Landscape'],
      ),
      Product(
        id: 'p11',
        title: 'Neon Dreams',
        description: 'Cyberpunk digital art.',
        price: 70.0,
        imageUrl: 'https://images.unsplash.com/photo-1495020689067-958852a7765e',
        categories: const ['Digital'],
      ),
      Product(
        id: 'p12',
        title: 'Marble Form',
        description: 'Minimal sculpture concept.',
        price: 200.0,
        imageUrl: 'https://images.unsplash.com/photo-1433840496881-cbd845929862',
        categories: const ['Sculpture'],
        isDigital: false,
      ),
    ];
  }
}

class _Banner extends StatelessWidget {
  final String imageUrl;
  const _Banner({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
