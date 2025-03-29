import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/bloc/auth_event.dart';
import 'package:mobile/features/profile/bloc/profile_event.dart';
import 'package:mobile/features/profile/bloc/profile_state.dart';
import 'package:mobile/features/profile/model/profile_model.dart';
import 'package:mobile/features/profile/service/profile_service.dart';
import '../bloc/profile_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(profileService: context.read<ProfileService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is ProfileLoaded) {
              _fullNameController.text = state.user.fullName ?? '';
              _emailController.text = state.user.email;
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return _buildProfileForm(context, state.user);
            }
            return const Center(child: Text('Failed to load profile'));
          },
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Username: ${user.username}', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          TextField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(
                    UpdateProfile(
                      fullName: _fullNameController.text.trim(),
                      email: _emailController.text.trim(),
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Update Profile'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout());
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}