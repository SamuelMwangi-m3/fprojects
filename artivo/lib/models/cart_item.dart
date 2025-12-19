class CartItem {
  final String productId;
  final String title;
  final String artist;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.artist,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}
