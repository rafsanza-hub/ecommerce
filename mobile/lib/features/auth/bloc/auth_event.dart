import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckStatus extends AuthEvent {}

class AuthLogin extends AuthEvent {
  final String usernameOrEmail;
  final String password;
  const AuthLogin(this.usernameOrEmail, this.password);
  @override
  List<Object?> get props => [usernameOrEmail, password];
}

class AuthRegister extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String? fullName;
  const AuthRegister(this.username, this.email, this.password, this.fullName);
  @override
  List<Object?> get props => [username, email, password, fullName];
}

class AuthLogout extends AuthEvent {}