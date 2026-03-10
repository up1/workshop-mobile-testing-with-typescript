/// Represents a product from the DummyJSON API.
class Product {
  /// Unique identifier for the product.
  final int id;

  /// Display title of the product.
  final String title;

  /// Price of the product.
  final double price;

  /// URL of the product thumbnail image.
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
  });

  /// Creates a [Product] from a JSON map.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
    );
  }
}
