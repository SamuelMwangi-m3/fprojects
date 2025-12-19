import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final SupabaseClient _client;
  OrderRepository(this._client);

  Future<List<Map<String, dynamic>>> listOrders() async {
    final res = await _client.from('orders').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    final res = await _client.from('orders').insert(payload).select().single();
    return Map<String, dynamic>.from(res);
  }
}


