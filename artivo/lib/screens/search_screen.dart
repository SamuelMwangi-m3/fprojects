import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/product_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _q = TextEditingController();
  String _artist = '';
  String _medium = '';
  RangeValues _price = const RangeValues(0, 1000);
  final List<Product> _results = [];
  late final ProductRepository _repo = ProductRepository(Supabase.instance.client);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _q,
          decoration: const InputDecoration(hintText: 'Search art, artists, styles...'),
          onSubmitted: (_) => _search(),
        ),
        actions: [
          IconButton(onPressed: _search, icon: const Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: const Text('Filters'),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Artist'),
                      onChanged: (v) => _artist = v,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Medium (e.g., painting, digital)'),
                      onChanged: (v) => _medium = v,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Price'),
                        Expanded(
                          child: RangeSlider(
                            values: _price,
                            min: 0,
                            max: 10000,
                            divisions: 100,
                            onChanged: (v) => setState(() => _price = v),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('No results yet'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (ctx, i) {
                      final p = _results[i];
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(p.imageUrl)),
                        title: Text(p.title),
                        subtitle: Text('${p.artist} • ${p.categories.join(', ')}'),
                        trailing: p.isVerified ? const Icon(Icons.verified, color: Colors.blue) : null,
                        onTap: () => Navigator.of(context).pushNamed('/product-detail', arguments: p),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Future<void> _search() async {
    final items = await _repo.search(
      query: _q.text,
      artist: _artist,
      medium: _medium,
      minPrice: _price.start,
      maxPrice: _price.end,
    );
    setState(() {
      _results
        ..clear()
        ..addAll(items);
    });
  }
}


