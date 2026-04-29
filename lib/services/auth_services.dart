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

      if (response['token'] != null) {
        ApiConfig.token = response['token']; 
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal login: ${e.toString()}');
    }
  }
}