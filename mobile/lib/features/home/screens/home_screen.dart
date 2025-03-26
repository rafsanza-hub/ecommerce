import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart'; // Import AuthBloc

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // You can access the authenticated user's data if needed
    // final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Dispatch logout event
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome! You are logged in.'),
            const SizedBox(height: 20),
             // Example: Display user email
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Text('Email: ${state.user.email}');
                }
                return const SizedBox.shrink(); // Or a placeholder
              },
            ),
          ],
        ),
      ),
    );
  }
}
