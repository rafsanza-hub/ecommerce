class User {
  final String token;
  final String id;
  final String username;
  final String email;

  const User({
    required this.token,
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return User(
      token: json['token'] as String,
      id: user['id'] as String,
      username: user['username'] as String,
      email: user['email'] as String,
    );
  }
}
