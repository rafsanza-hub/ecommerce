import 'package:mobile/core/helpers/http_helper.dart';
import '../model/order_model.dart';

class OrderService {
  Future<OrderModel> createOrder() async {
    final response = await HttpHelper.post('/orders', body: {});
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: OrderModel.fromJson,
    );
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await HttpHelper.get('/orders');
    return await HttpHelper.handleListResponse(
      response: response,
      fromJson: (json) => json.map((item) => OrderModel.fromJson(item)).toList(),
    );
  }

  Future<OrderModel> getOrderById(String id) async {
    final response = await HttpHelper.get('/orders/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: OrderModel.fromJson,
    );
  }
}