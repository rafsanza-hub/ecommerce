import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/order/service/order_service.dart';
import '../bloc/order_history_bloc.dart';
import '../bloc/order_history_event.dart';
import '../bloc/order_history_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderHistoryBloc(orderService: context.read<OrderService>())
        ..add(const LoadOrderHistory()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Order History')),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderHistoryLoaded) {
              if (state.orders.isEmpty) {
                return const Center(child: Text('No orders found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text('Order #${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total: Rp ${order.total}'),
                          Text('Status: ${order.status}'),
                          if (order.payment != null)
                            Text('Payment: ${order.payment!.status} (${order.payment!.paymentType})'),
                        ],
                      ),
                      trailing: Text(order.createdAt.toLocal().toString().split('.')[0]),
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Load order history'));
          },
        ),
      ),
    );
  }
}