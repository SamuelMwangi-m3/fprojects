import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductRepository {
  final SupabaseClient _client;
  ProductRepository(this._client);

  Future<List<Product>> listFeatured({int limit = 20}) async {
    final res = await _client.from('products').select().limit(limit);
    return (res as List<dynamic>).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Product>> search({String? query, String? artist, String? medium, double? minPrice, double? maxPrice, int limit = 50}) async {
    final res = await _client.from('products').select().limit(limit);
    final items = (res as List<dynamic>).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    return items.where((p) {
      final qOk = (query == null || query.isEmpty) ||
          p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.description.toLowerCase().contains(query.toLowerCase());
      final aOk = (artist == null || artist.isEmpty) || p.artist.toLowerCase().contains(artist.toLowerCase());
      final mOk = (medium == null || medium.isEmpty) || p.categories.any((c) => c.toLowerCase().contains(medium.toLowerCase()));
      final minOk = (minPrice == null) || p.price >= minPrice;
      final maxOk = (maxPrice == null) || p.price <= maxPrice;
      return qOk && aOk && mOk && minOk && maxOk;
    }).toList();
  }
}


