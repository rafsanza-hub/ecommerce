import 'package:mobile/core/helpers/http_helper.dart';
import '../model/order_model.dart';
import 'package:flutter/foundation.dart';

class OrderService {
  Future<OrderModel> createOrder(ShippingAddress shippingAddress) async {
    final response = await HttpHelper.post('/orders', body: {
      'shippingAddress': shippingAddress.toJson(),
    });
    if (kDebugMode) print('CreateOrder Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: OrderModel.fromJson,
    );
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await HttpHelper.get('/orders');
    if (kDebugMode) print('GetOrders Response: ${response.body}');
    return await HttpHelper.handleListResponse(
      response: response,
      fromJson: (json) {
        final data = (json as Map<String, dynamic>)['data'] as List<dynamic>? ?? [];
        return data.map((item) => OrderModel.fromJson(item as Map<String, dynamic>)).toList();
      },
    );
  }

  Future<OrderModel> getOrderById(String id) async {
    final response = await HttpHelper.get('/orders/$id');
    if (kDebugMode) print('GetOrderById Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: OrderModel.fromJson,
    );
  }
}