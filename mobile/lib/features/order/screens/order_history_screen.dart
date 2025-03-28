import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/order/bloc/order_event.dart';
import 'package:mobile/features/order/bloc/order_state.dart';
import 'package:mobile/features/order/service/order_service.dart';
import '../bloc/order_bloc.dart';
import '../model/order_model.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc(orderService: context.read<OrderService>())..add(FetchOrders()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Order History')),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersLoaded) {
              return _buildOrderList(state.orders);
            } else {
              return const Center(child: Text('No orders found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text('Order #${order.id}'),
            subtitle: Text('Status: ${order.status} | ${order.createdAt.toLocal().toString().split('.')[0]}'),
            trailing: Text('Rp ${order.total}'),
            onTap: () {
              // Opsional: Navigasi ke detail pesanan
            },
          ),
        );
      },
    );
  }
}