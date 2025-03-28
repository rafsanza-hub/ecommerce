import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/payment/bloc/payment_event.dart';
import 'package:mobile/features/payment/bloc/payment_state.dart';
import 'package:mobile/features/payment/service/payment_service.dart';
import '../bloc/payment_bloc.dart';
import '../../order/model/order_model.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel order;

  const PaymentScreen({super.key, required this.order});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'cod'; // Default: Cash on Delivery

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(paymentService: context.read<PaymentService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              Navigator.pop(context); // Kembali ke OrderScreen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment processed successfully')),
              );
            } else if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is PaymentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildPaymentForm(context);
          },
        ),
      ),
    );
  }

  Widget _buildPaymentForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order #${widget.order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Total: Rp ${widget.order.total}', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 32),
          const Text('Select Payment Method:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: const Text('Cash on Delivery'),
            value: 'cod',
            groupValue: _selectedMethod,
            onChanged: (value) => setState(() => _selectedMethod = value!),
          ),
          RadioListTile<String>(
            title: const Text('Bank Transfer'),
            value: 'bank_transfer',
            groupValue: _selectedMethod,
            onChanged: (value) => setState(() => _selectedMethod = value!),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<PaymentBloc>().add(ProcessPayment(widget.order.id, _selectedMethod));
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Process Payment'),
          ),
        ],
      ),
    );
  }
}