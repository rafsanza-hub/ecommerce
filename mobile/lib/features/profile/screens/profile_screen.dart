import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/core/constants/colors.dart';
import 'package:mobile/core/constants/sizes.dart';
import 'package:mobile/features/auth/bloc/auth_bloc.dart';
import 'package:mobile/features/auth/bloc/auth_event.dart';
import 'package:mobile/features/profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      'User',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'rafsan@gmail.com',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/profile-detail'),
                        child: const Text('Edit Profil'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Settings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildLanguageTile(context),
                  _buildDarkModeTile(context),
                  _buildNotificationTile(context),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.read<AuthBloc>().add(AuthLogout()),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Language selection tile
  Widget _buildLanguageTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Iconsax.language_square),
      title: const Text('Bahasa'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Indonesia', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: TSizes.sm),
          const Icon(Iconsax.arrow_right_3),
        ],
      ),
      onTap: () {},
    );
  }

  // Dark mode toggle tile
  Widget _buildDarkModeTile(BuildContext context) {
    // Menggunakan GetX untuk mendeteksi tema saat ini
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: const Icon(Iconsax.moon),
      title: const Text('Mode Gelap'),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {},
        activeColor: TColors.primary,
      ),
    );
  }

  // Notification settings tile
  Widget _buildNotificationTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Iconsax.notification),
      title: const Text('Notifikasi'),
      trailing: const Icon(Iconsax.arrow_right_3),
      onTap: () {},
    );
  }
}
