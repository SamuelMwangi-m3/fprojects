import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final Map<String, CartItem> _itemsById = {};

  List<CartItem> get items => _itemsById.values.toList(growable: false);

  void add(Product product, {int quantity = 1}) {
    final existing = _itemsById[product.id];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _itemsById[product.id] = CartItem(product: product, quantity: quantity);
    }
  }

  void remove(String productId) {
    _itemsById.remove(productId);
  }

  void decrease(String productId) {
    final existing = _itemsById[productId];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      _itemsById.remove(productId);
    } else {
      existing.quantity -= 1;
    }
  }

  void clear() {
    _itemsById.clear();
  }

  int get totalItems {
    int count = 0;
    for (final item in _itemsById.values) {
      count += item.quantity;
    }
    return count;
  }

  double get totalPrice {
    double total = 0;
    for (final item in _itemsById.values) {
      total += item.product.price * item.quantity;
    }
    return total;
  }
}


