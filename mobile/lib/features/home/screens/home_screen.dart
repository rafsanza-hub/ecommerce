import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/features/cart/screens/cart_screen.dart';
import 'package:mobile/features/category/screens/category_list_screen.dart';
import 'package:mobile/features/home/cubit/navigation_cubit.dart';
import 'package:mobile/features/product/screens/product_list_screen.dart';
import 'package:mobile/features/profile/screens/profile_screen.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const _BottomNavbarView(),
    );
  }
}

class _BottomNavbarView extends StatelessWidget {
  const _BottomNavbarView();

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ProductListScreen(),
      const CategoryListScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return screens[selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return NavigationBar(
            onDestinationSelected: (index) =>
                context.read<NavigationCubit>().changeIndex(index),
            height: 80,
            elevation: 0,
            selectedIndex: selectedIndex,
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Iconsax.category), label: 'Kategori'),
              NavigationDestination(
                  icon: Icon(Iconsax.bucket), label: 'Kalender'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
            ],
          );
        },
      ),
    );
  }
}
