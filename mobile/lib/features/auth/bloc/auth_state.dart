part of 'auth_bloc.dart';

// Imports are moved to auth_bloc.dart

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Kondisi awal, sebelum memeriksa status autentikasi
final class AuthInitial extends AuthState {}

// Kondisi ketika operasi autentikasi sedang berlangsung
final class AuthLoading extends AuthState {}

// Kondisi ketika pengguna berhasil diautentikasi
final class AuthAuthenticated extends AuthState {
  final AuthModel user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// Kondisi ketika pengguna tidak diautentikasi
final class AuthUnauthenticated extends AuthState {}

// Kondisi ketika operasi autentikasi gagal
final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
