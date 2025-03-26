import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart'; // Import the actual HomeScreen

void main() {
  // You might need WidgetsFlutterBinding.ensureInitialized() if you do async work before runApp
  // WidgetsFlutterBinding.ensureInitialized(); 
  
  // Instantiate AuthService
  final AuthService authService = AuthService();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    // Provide the AuthBloc to the entire application
    return BlocProvider(
      create: (context) => AuthBloc(authService: authService),
      child: MaterialApp(
        title: 'E-commerce App', // Give your app a title
        theme: ThemeData(
          primarySwatch: Colors.blue, // Customize theme as needed
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(), // Use a wrapper to decide which screen to show
      ),
    );
  }
}

// This widget listens to AuthState and builds the appropriate UI
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          // If authenticated, show HomeScreen
          return const HomeScreen(); 
        } else if (state is AuthUnauthenticated || state is AuthFailure) {
          // If unauthenticated or login failed, show LoginScreen
          return const LoginScreen();
        } else {
          // If AuthInitial or AuthLoading, show a loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

// Remove the old placeholder HomeScreen definition from here if it exists
