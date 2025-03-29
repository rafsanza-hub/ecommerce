import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:mobile/features/auth/bloc/auth_state.dart';
import 'package:mobile/features/auth/services/auth_service.dart';
import 'package:mobile/features/cart/model/cart_model.dart';
import 'package:mobile/features/order/model/order_model.dart';
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
import 'features/order/screens/order_screen.dart';
import 'features/order/screens/order_history_screen.dart';
import 'features/order/service/order_service.dart';
import 'features/payment/screens/payment_screen.dart';
import 'features/payment/service/payment_service.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/service/profile_service.dart';

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
  final orderService = OrderService();
  final paymentService = PaymentService();
  final profileService = ProfileService();

  runApp(MyApp(
    authService: authService,
    productService: productService,
    categoryService: categoryService,
    cartService: cartService,
    orderService: orderService,
    paymentService: paymentService,
    profileService: profileService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final ProductService productService;
  final CategoryService categoryService;
  final CartService cartService;
  final OrderService orderService;
  final PaymentService paymentService;
  final ProfileService profileService;

  const MyApp({
    super.key,
    required this.authService,
    required this.productService,
    required this.categoryService,
    required this.cartService,
    required this.orderService,
    required this.paymentService,
    required this.profileService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authService: authService)),
        BlocProvider(create: (_) => CartBloc(cartService: cartService)),
        RepositoryProvider.value(value: productService),
        RepositoryProvider.value(value: categoryService),
        RepositoryProvider.value(value: cartService),
        RepositoryProvider.value(value: orderService),
        RepositoryProvider.value(value: paymentService),
        RepositoryProvider.value(value: profileService),
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
          '/order': (_) =>
              const OrderScreen(cart: CartModel(id: '', items: [], total: 0)),
          '/order_history': (_) => const OrderHistoryScreen(),
          '/payment': (_) => PaymentScreen(
              order: OrderModel(
                  id: '',
                  userId: '',
                  items: [],
                  total: 0,
                  status: 'pending',
                  createdAt: DateTime.now())),
          '/profile': (_) => const ProfileScreen(),
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
