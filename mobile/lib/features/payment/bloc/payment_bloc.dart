import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/payment_service.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService paymentService;

  PaymentBloc({required this.paymentService}) : super(PaymentInitial()) {
    on<ProcessPayment>(_onProcessPayment);
    on<FetchPayment>(_onFetchPayment);
  }

  Future<void> _onProcessPayment(ProcessPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payment = await paymentService.createPayment(event.orderId, event.method);
      emit(PaymentSuccess(payment));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onFetchPayment(FetchPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payment = await paymentService.getPaymentById(event.paymentId);
      emit(PaymentSuccess(payment));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}