class Product {
  final String id;
  final String name;
  final int price;
  final String category;

  Product({required this.id, required this.name, required this.price, required this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      category: json['category'] is Map ? json['category']['name'] : (json['category'] ?? 'General'),
    );
  }
}