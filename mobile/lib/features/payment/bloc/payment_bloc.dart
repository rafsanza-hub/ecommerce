import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/payment_service.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import 'package:flutter/foundation.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService paymentService;

  PaymentBloc({required this.paymentService}) : super(PaymentInitial()) {
    on<ProcessPayment>(_onProcessPayment);
  }

  Future<void> _onProcessPayment(ProcessPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payment = await paymentService.createPayment(event.orderId, event.paymentType); // Ubah dari paymentMethod
      emit(PaymentSuccess(payment));
    } catch (e) {
      if (kDebugMode) print('ProcessPayment Error: $e');
      emit(PaymentError(e.toString()));
    }
  }
}