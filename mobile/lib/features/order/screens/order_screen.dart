import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/order/bloc/order_event.dart';
import 'package:mobile/features/order/bloc/order_state.dart';
import 'package:mobile/features/order/service/order_service.dart';
import '../bloc/order_bloc.dart';
import '../../cart/model/cart_model.dart';
import '../../payment/screens/payment_screen.dart';

class OrderScreen extends StatelessWidget {
  final CartModel cart;

  const OrderScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc(orderService: context.read<OrderService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderCreated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PaymentScreen(order: state.order)),
              );
            } else if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildOrderSummary(context, cart);
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartModel cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                title: Text(item.product.name),
                subtitle: Text('Qty: ${item.quantity}'),
                trailing: Text('Rp ${(item.product.price * item.quantity).toString()}'),
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
            onPressed: () => context.read<OrderBloc>().add(CreateOrder()),
            child: const Text('Place Order'),
          ),
        ),
      ],
    );
  }
}