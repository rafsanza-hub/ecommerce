import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {}

class FetchOrders extends OrderEvent {}

class FetchOrderById extends OrderEvent {
  final String id;
  const FetchOrderById(this.id);
  @override
  List<Object?> get props => [id];
}