import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/order/bloc/order_event.dart';
import 'package:mobile/features/order/bloc/order_state.dart';
import 'package:mobile/features/order/service/order_service.dart';
import '../bloc/order_bloc.dart';
import '../../cart/model/cart_model.dart';
import '../model/order_model.dart';
import '../../payment/screens/payment_screen.dart';

class OrderScreen extends StatefulWidget {
  final CartModel cart;

  const OrderScreen({super.key, required this.cart});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'Indonesia');

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

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
            return _buildOrderSummary(context, widget.cart);
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartModel cart) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Rp ${cart.total}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _streetController,
            decoration: const InputDecoration(labelText: 'Street', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _postalCodeController,
            decoration: const InputDecoration(labelText: 'Postal Code', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _countryController,
            decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              final shippingAddress = ShippingAddress(
                street: _streetController.text.trim(),
                city: _cityController.text.trim(),
                postalCode: _postalCodeController.text.trim(),
                country: _countryController.text.trim(),
              );
              context.read<OrderBloc>().add(CreateOrder(shippingAddress));
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}