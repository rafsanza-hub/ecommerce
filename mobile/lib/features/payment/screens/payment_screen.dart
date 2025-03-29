import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/payment/bloc/payment_event.dart';
import 'package:mobile/features/payment/bloc/payment_state.dart';
import 'package:mobile/features/payment/service/payment_service.dart';
import '../bloc/payment_bloc.dart';
import '../../order/model/order_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel order;

  const PaymentScreen({super.key, required this.order});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentType = 'credit_card';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(paymentService: context.read<PaymentService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment initiated. Redirecting...'), backgroundColor: Colors.green),
              );
              if (state.payment.paymentUrl != null) {
                _launchUrl(state.payment.paymentUrl!);
              } else {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            } else if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
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
          Text('Order ID: ${widget.order.id}'),
          const SizedBox(height: 16),
          Text('Total: Rp ${widget.order.total}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          const Text('Payment Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedPaymentType,
            onChanged: (value) {
              setState(() {
                _selectedPaymentType = value!;
              });
            },
            items: const [
              DropdownMenuItem(value: 'credit_card', child: Text('Credit Card')),
              DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
              DropdownMenuItem(value: 'e_wallet', child: Text('E-Wallet')),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<PaymentBloc>().add(ProcessPayment(widget.order.id, _selectedPaymentType));
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text('Process Payment'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}