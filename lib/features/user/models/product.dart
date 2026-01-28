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
}
