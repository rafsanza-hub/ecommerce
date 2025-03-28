import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:mobile/features/auth/bloc/auth_state.dart';
import 'package:mobile/features/auth/services/auth_service.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/product/screens/product_list_screen.dart';
import 'features/product/service/product_service.dart';
import 'features/category/screens/category_list_screen.dart';
import 'features/category/service/category_service.dart';
import 'features/cart/screens/cart_screen.dart';
import 'features/cart/service/cart_service.dart';
import 'features/cart/bloc/cart_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final authService = AuthService();
  final productService = ProductService();
  final categoryService = CategoryService();
  final cartService = CartService();

  runApp(MyApp(
    authService: authService,
    productService: productService,
    categoryService: categoryService,
    cartService: cartService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final ProductService productService;
  final CategoryService categoryService;
  final CartService cartService;

  const MyApp({
    super.key,
    required this.authService,
    required this.productService,
    required this.categoryService,
    required this.cartService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authService: authService)),
        BlocProvider(create: (_) => CartBloc(cartService: cartService)), // Global CartBloc
        RepositoryProvider.value(value: productService),
        RepositoryProvider.value(value: categoryService),
        RepositoryProvider.value(value: cartService),
      ],
      child: MaterialApp(
        title: 'E-commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const AuthWrapper(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/products': (_) => const ProductListScreen(),
          '/categories': (_) => const CategoryListScreen(),
          '/cart': (_) => const CartScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else if (state is AuthUnauthenticated || state is AuthFailure) {
          return const LoginScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}