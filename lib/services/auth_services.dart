import '../core/api_client.dart';
import '../core/api_config.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> loginPos(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/login/pos', 
        body: {
          'email': email,
          'password': password,
        },
      );

      print("RESPONSE SERVER: $response");

      if (response['token'] != null) {
        ApiConfig.token = response['token']; 
        return true;
      } 
      else if (response['data'] != null && response['data']['token'] != null) {
        ApiConfig.token = response['data']['token'];
        return true;
      }
      
      return false; // Kembalikan false jika tidak ada token yang ditemukan
    } catch (e) {
      throw Exception('Gagal login: ${e.toString()}');
    }
  }
}