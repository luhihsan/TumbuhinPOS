import '../core/api_client.dart';
import '../models/product_model.dart';

class ProductService {
  final ApiClient _client = ApiClient();

  Future<List<Product>> fetchProducts() async {
    final response = await _client.get('/api/products?page=1&limit=50&isActive=true');
    
    List data = response['data']; 
    return data.map((json) => Product.fromJson(json)).toList();
  }
}