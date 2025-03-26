import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String token; // The JWT token

  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  // Factory constructor to create an AuthModel from JSON
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      // Adjust field names based on your actual backend response
      id: json['_id'] ?? json['id'] ?? '', 
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '', 
    );
  }

  // Method to convert AuthModel to JSON (optional, might be useful)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [id, name, email, token];
}
