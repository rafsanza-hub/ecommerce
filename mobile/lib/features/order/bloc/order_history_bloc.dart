import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/order_service.dart';
import 'order_history_event.dart';
import 'order_history_state.dart';
import 'package:flutter/foundation.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderService orderService;

  OrderHistoryBloc({required this.orderService}) : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
  }

  Future<void> _onLoadOrderHistory(LoadOrderHistory event, Emitter<OrderHistoryState> emit) async {
    emit(OrderHistoryLoading());
    try {
      final orders = await orderService.getOrders(); // Gunakan getOrders yang ada
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      if (kDebugMode) print('LoadOrderHistory Error: $e');
      emit(OrderHistoryError(e.toString()));
    }
  }
}