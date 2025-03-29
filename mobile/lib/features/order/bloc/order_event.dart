import 'package:equatable/equatable.dart';
import '../model/order_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final ShippingAddress shippingAddress; // Tambah parameter ini

  const CreateOrder(this.shippingAddress);

  @override
  List<Object?> get props => [shippingAddress];
}

class FetchOrders extends OrderEvent {}