import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiClient {
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json', 
    };
    if (ApiConfig.token != null) {
      headers['Authorization'] = 'Bearer ${ApiConfig.token}';
    }
    return headers;
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }
}