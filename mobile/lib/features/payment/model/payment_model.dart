import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String id;
  final String orderId;
  final int amount;
  final String method; // e.g., "cod", "bank_transfer", "midtrans"
  final String status; // pending, completed, failed
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      amount: json['amount'] as int,
      method: json['method'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, orderId, amount, method, status, createdAt];
}