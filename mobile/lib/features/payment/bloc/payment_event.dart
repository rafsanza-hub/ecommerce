import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class ProcessPayment extends PaymentEvent {
  final String orderId;
  final String method;
  const ProcessPayment(this.orderId, this.method);
  @override
  List<Object?> get props => [orderId, method];
}

class FetchPayment extends PaymentEvent {
  final String paymentId;
  const FetchPayment(this.paymentId);
  @override
  List<Object?> get props => [paymentId];
}