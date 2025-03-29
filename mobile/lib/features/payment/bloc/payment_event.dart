import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class ProcessPayment extends PaymentEvent {
  final String orderId;
  final String paymentType; // Ubah dari paymentMethod

  const ProcessPayment(this.orderId, this.paymentType);

  @override
  List<Object?> get props => [orderId, paymentType];
}