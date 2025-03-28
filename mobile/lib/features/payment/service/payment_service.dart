import 'package:mobile/core/helpers/http_helper.dart';
import '../model/payment_model.dart';

class PaymentService {
  Future<PaymentModel> createPayment(String orderId, String method) async {
    final response = await HttpHelper.post('/payments', body: {
      'orderId': orderId,
      'method': method,
    });
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: PaymentModel.fromJson,
    );
  }

  Future<PaymentModel> getPaymentById(String id) async {
    final response = await HttpHelper.get('/payments/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: PaymentModel.fromJson,
    );
  }
}