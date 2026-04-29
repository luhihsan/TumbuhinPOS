class Product {
  final String id;
  final String name;
  final String category;
  final int price; 
  final String? imageAsset;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageAsset,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      category: json['category'] is Map ? json['category']['name'] : (json['category'] ?? 'General'),
      imageAsset: json['imageAsset'],
    );
  }
}

enum OrderType { dineIn, takeAway }

class OrderItemDraft {
  final Product product;
  int qty;
  OrderType orderType;
  int price; 
  String note;

  OrderItemDraft({
    required this.product,
    this.qty = 1,
    this.orderType = OrderType.dineIn,
    required this.price,
    this.note = '',
  });

  int get lineTotal => qty * price;
}