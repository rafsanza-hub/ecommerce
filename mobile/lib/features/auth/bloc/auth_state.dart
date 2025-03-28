import 'package:equatable/equatable.dart';
import 'package:mobile/features/auth/models/auth_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthModel? auth; // Opsional, bisa null kalau hanya cek token
  const AuthAuthenticated({this.auth});
  @override
  List<Object?> get props => [auth];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}