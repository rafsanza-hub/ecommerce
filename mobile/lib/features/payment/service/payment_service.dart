import 'package:mobile/core/helpers/http_helper.dart';
import '../model/payment_model.dart';
import 'package:flutter/foundation.dart';

class PaymentService {
  Future<PaymentModel> createPayment(String orderId, String paymentType) async { // Ubah dari paymentMethod
    final response = await HttpHelper.post('/payments', body: {
      'orderId': orderId,
      'paymentType': paymentType, // Ubah dari paymentMethod
    });
    if (kDebugMode) print('CreatePayment Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: PaymentModel.fromJson,
    );
  }
}