import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) { // Mulai dengan status AuthInitial
    on<AuthCheckStatusRequested>(_onAuthCheckStatusRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    // Segera periksa status saat BLoC dibuat
    add(AuthCheckStatusRequested()); 
  }

  Future<void> _onAuthCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final bool hasToken = await _authService.hasToken();
      if (hasToken) {
        // Jika ada token, kita mungkin ingin memverifikasinya atau mengambil data pengguna
        // Untuk saat ini, kita asumsikan kehadiran token berarti sudah diautentikasi
        // Dalam aplikasi sebenarnya, Anda mungkin akan mengambil detail pengguna menggunakan token di sini
        // dan berpotensi memancarkan AuthAuthenticated dengan data pengguna yang sebenarnya.
        // Jika pengambilan data pengguna gagal (misalnya, token kedaluwarsa), pancarkan AuthUnauthenticated.
        
        // Placeholder: Memancarkan Unauthenticated untuk saat ini jika hanya pengecekan token yang dilakukan.
        // Ganti logika ini dengan pengambilan/validasi pengguna yang sebenarnya jika diperlukan.
        // Untuk pengaturan dasar, hanya memeriksa keberadaan token mungkin cukup pada awalnya.
        // Mari kita asumsikan untuk saat ini jika token ada, kita perlu pengguna untuk masuk lagi untuk mendapatkan data segar.
        // Atau, jika Anda menyimpan data pengguna bersama token, Anda dapat memuatnya.
        
        // Opsi 1: Asumsikan token berarti sudah masuk (paling sederhana, tetapi kurang aman/kuat)
        // final token = await _authService.getToken();
        // emit(AuthAuthenticated(user: AuthModel(id: 'temp', name: 'User', email: 'user@example.com', token: token!))); // Ganti dengan pemuatan pengguna yang sebenarnya

        // Opsi 2: Memerlukan login bahkan jika token ada (lebih aman jika token mungkin sudah kedaluwarsa)
         emit(AuthUnauthenticated()); 

      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(message: 'Gagal memeriksa status autentikasi: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService.login(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
      // Secara opsional, kembali ke Unauthenticated setelah menampilkan kegagalan
      await Future.delayed(const Duration(seconds: 2)); // Beri waktu untuk melihat kesalahan
       if (state is AuthFailure) { // Periksa apakah status masih gagal sebelum memancarkan unauthenticated
         emit(AuthUnauthenticated());
       }
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
       await Future.delayed(const Duration(seconds: 2));
       if (state is AuthFailure) {
         emit(AuthUnauthenticated());
       }
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Bahkan jika logout gagal, perlakukan pengguna sebagai tidak diautentikasi di sisi klien
      emit(AuthUnauthenticated()); 
      print('Kesalahan Logout: ${e.toString()}'); // Catat kesalahan
    }
  }
}
