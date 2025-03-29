import 'package:mobile/core/helpers/http_helper.dart';
import 'package:mobile/features/auth/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const String _tokenKey = 'auth_token';

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print('Get token: ${prefs.getString(_tokenKey)}');
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<AuthModel> login(String usernameOrEmail, String password) async {
    final response = await HttpHelper.post('/auth/login', body: {
      'usernameOrEmail': usernameOrEmail,
      'password': password,
    });

    final auth = await HttpHelper.handleResponse(
      response: response,
      fromJson: AuthModel.fromJson,
    );
    await _saveToken(auth.token);
    return auth;
  }

  Future<AuthModel> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await HttpHelper.post('/auth/register', body: {
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
    });

    final auth = await HttpHelper.handleResponse(
      response: response,
      fromJson: AuthModel.fromJson,
    );
    await _saveToken(auth.token);
    return auth;
  }

  Future<void> logout() async {
    await deleteToken();
  }
}