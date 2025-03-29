import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/order_service.dart';
import 'order_event.dart';
import 'order_state.dart';
import 'package:flutter/foundation.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService orderService;

  OrderBloc({required this.orderService}) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<FetchOrders>(_onFetchOrders);
  }

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final order = await orderService.createOrder(event.shippingAddress);
      emit(OrderCreated(order));
    } catch (e) {
      if (kDebugMode) print('CreateOrder Error: $e');
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onFetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await orderService.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      if (kDebugMode) print('FetchOrders Error: $e');
      emit(OrderError(e.toString()));
    }
  }
}