part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk memicu pengecekan status autentikasi saat ini (misalnya, saat aplikasi dimulai)
final class AuthCheckStatusRequested extends AuthEvent {}

// Event yang dipicu ketika pengguna mencoba masuk
final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Event yang dipicu ketika pengguna mencoba mendaftar
final class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}


// Event yang dipicu ketika pengguna keluar
final class AuthLogoutRequested extends AuthEvent {}
