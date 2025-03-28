import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/api_config.dart'; // Pindah baseUrl ke config

class HttpHelper {
  static const String _tokenKey = 'auth_token';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return await http.get(url, headers: headers).timeout(Duration(seconds: 10));
  }

  static Future<http.Response> post(String endpoint, {dynamic body}) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return await http
        .post(url, headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 10));
  }

  static Future<http.Response> put(String endpoint, {dynamic body}) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return await http
        .put(url, headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 10));
  }

  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    return await http.delete(url, headers: headers).timeout(Duration(seconds: 10));
  }

  static dynamic _processResponse(http.Response response) {
    final data = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
      case 201:
        return data['data']; 
      case 400:
        throw Exception(data['message'] ?? 'Bad request');
      case 401:
        throw Exception('Unauthorized: Please log in again');
      case 404:
        throw Exception(data['message'] ?? 'Resource not found');
      case 500:
        throw Exception(data['message'] ?? 'Server error');
      default:
        throw Exception('Unexpected error: ${response.statusCode}');
    }
  }

  // Untuk object tunggal
  static Future<T> handleResponse<T>({
    required http.Response response,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final data = _processResponse(response);
    return fromJson(data as Map<String, dynamic>);
  }

  // Untuk list
  static Future<T> handleListResponse<T>({
    required http.Response response,
    required T Function(List<dynamic>) fromJson,
  }) async {
    final data = _processResponse(response);
    return fromJson(data as List<dynamic>);
  }

}