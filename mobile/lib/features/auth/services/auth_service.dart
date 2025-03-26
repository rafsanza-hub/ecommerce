import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

class AuthService {
  // Adjust the base URL if your backend runs on a different port or path
  final String _baseUrl = 'http://localhost:5000/api/auth'; // Assuming '/api/auth' prefix for auth routes
  static const String _tokenKey = 'jwt_token';

  // --- Token Management ---

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // --- API Calls ---

  Future<AuthModel> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login'); // Adjust endpoint if needed
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Assuming the backend returns user data and token nested under a key like 'data' or directly
        // Adjust 'token' and user data keys based on your actual backend response structure
        final Map<String, dynamic> userData = responseData['user'] ?? responseData; // Example: check for 'user' key first
        final String token = responseData['token'] ?? ''; 

        if (token.isEmpty) {
           throw Exception('Login successful, but no token received.');
        }
        
        final authData = AuthModel.fromJson({...userData, 'token': token});
        await _saveToken(authData.token);
        return authData;

      } else {
        // Attempt to parse error message from backend
        String errorMessage = 'Login failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Login failed with status code: ${response.statusCode}';
        } catch (_) {
          errorMessage = 'Login failed with status code: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Login Error: $e'); // Log the error for debugging
      throw Exception('An error occurred during login. Please try again.');
    }
  }

  // Example Registration method - Adapt to your backend endpoint and payload
  Future<AuthModel> register({
      required String name, 
      required String email, 
      required String password
  }) async {
    final url = Uri.parse('$_baseUrl/register'); // Adjust endpoint if needed
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name, 
          'email': email, 
          'password': password
        }),
      );

       if (response.statusCode == 201 || response.statusCode == 200) { // Handle 201 Created or 200 OK
        final responseData = jsonDecode(response.body);
        final Map<String, dynamic> userData = responseData['user'] ?? responseData;
        final String token = responseData['token'] ?? '';

        if (token.isEmpty) {
           throw Exception('Registration successful, but no token received.');
        }

        final authData = AuthModel.fromJson({...userData, 'token': token});
        await _saveToken(authData.token);
        return authData;
      } else {
        String errorMessage = 'Registration failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Registration failed with status code: ${response.statusCode}';
        } catch (_) {
           errorMessage = 'Registration failed with status code: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Registration Error: $e');
      throw Exception('An error occurred during registration. Please try again.');
    }
  }

  Future<void> logout() async {
    await deleteToken();
    // Optionally: Call a backend logout endpoint if it exists
    // final url = Uri.parse('$_baseUrl/logout');
    // try {
    //   final token = await getToken(); // Get token to potentially invalidate it on backend
    //   if (token != null) {
    //     await http.post(url, headers: {'Authorization': 'Bearer $token'});
    //   }
    // } catch (e) {
    //   print('Logout API call failed: $e');
    // }
  }
}
