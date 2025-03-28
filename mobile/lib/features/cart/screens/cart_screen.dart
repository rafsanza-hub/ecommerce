import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/cart/bloc/cart_event.dart';
import 'package:mobile/features/cart/bloc/cart_state.dart';
import 'package:mobile/features/cart/service/cart_service.dart';
import '../bloc/cart_bloc.dart';
import '../model/cart_model.dart';
import '../../order/screens/order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(cartService: context.read<CartService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              return _buildCartList(context, state.cart);
            } else {
              return const Center(child: Text('Your cart is empty'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartModel cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: item.product.imageUrl.isNotEmpty
                      ? Image.network(item.product.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported, size: 50),
                  title: Text(item.product.name),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => context.read<CartBloc>().add(
                              UpdateCartItem(item.id, item.quantity - 1),
                            ),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => context.read<CartBloc>().add(
                              UpdateCartItem(item.id, item.quantity + 1),
                            ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Rp ${(item.product.price * item.quantity).toString()}'),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => context.read<CartBloc>().add(
                              RemoveFromCart(item.id),
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Rp ${cart.total}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderScreen(cart: cart)),
              );
            },
            child: const Text('Checkout'),
          ),
        ),
      ],
    );
  }
}