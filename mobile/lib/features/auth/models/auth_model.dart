import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  final String token;
  final String id;
  final String username;
  final String email;

  const AuthModel({
    required this.token,
    required this.id,
    required this.username,
    required this.email,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthModel(
      token: json['token'] as String,
      id: user['id'] as String,
      username: user['username'] as String,
      email: user['email'] as String,
    );
  }

  @override
  List<Object?> get props => [token, id, username, email];
}