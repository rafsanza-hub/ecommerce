import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String orderId;
  final String paymentType;
  final int amount;
  final String status;
  final String? transactionId;
  final String? paymentUrl;
  final DateTime? paymentDate;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.paymentType,
    required this.amount,
    required this.status,
    this.transactionId,
    this.paymentUrl,
    this.paymentDate,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String? ?? '',
      orderId: json['order'] as String? ??
          json['orderId'] as String? ??
          '', // Handle 'order' atau 'orderId'
      paymentType: json['paymentType'] as String? ?? 'unknown',
      amount: json['amount'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      transactionId: json['transactionId'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'] as String)
          : null,
      createdAt: DateTime.parse(
          json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        paymentType,
        amount,
        status,
        transactionId,
        paymentUrl,
        paymentDate,
        createdAt,
      ];
}
