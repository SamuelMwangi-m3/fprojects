import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class WishlistRepository {
  final SupabaseClient _client;
  WishlistRepository(this._client);

  Future<List<Product>> list() async {
    final res = await _client
        .from('wishlist')
        .select('product:products(*)')
        .order('created_at', ascending: false);
    final rows = res as List<dynamic>;
    return rows
        .map((e) => Product.fromJson((e as Map<String, dynamic>)['product'] as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isWishlisted(String productId, String userId) async {
    final res = await _client
        .from('wishlist')
        .select('id')
        .eq('product_id', productId)
        .eq('user_id', userId)
        .maybeSingle();
    return res != null;
  }

  Future<void> add(String productId, String userId) async {
    await _client.from('wishlist').insert({'product_id': productId, 'user_id': userId});
  }

  Future<void> remove(String productId, String userId) async {
    await _client
        .from('wishlist')
        .delete()
        .eq('product_id', productId)
        .eq('user_id', userId);
  }
}


