class Product {
  final String id;
  final String title;
  final String artist;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> categories;
  final bool isDigital;
  final DateTime createdAt;
  final bool isVerified;

  Product({
    required this.id,
    required this.title,
    this.artist = '',
    required this.description,
    required this.price,
    required this.imageUrl,
    this.categories = const [],
    this.isDigital = false,
    this.isVerified = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      artist: json['artist'] ?? '',
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      categories: json['categories'] != null ? List<String>.from(json['categories']) : const [],
      isDigital: json['isDigital'] ?? false,
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categories': categories,
      'isDigital': isDigital,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
