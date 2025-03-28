import 'package:mobile/core/helpers/http_helper.dart';
import '../model/cart_model.dart';

class CartService {
  Future<CartModel> getCart() async {
    final response = await HttpHelper.get('/cart');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }

  Future<CartModel> addToCart(String productId, int quantity) async {
    final response = await HttpHelper.post('/cart', body: {
      'productId': productId,
      'quantity': quantity,
    });
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }

  Future<CartModel> updateCartItem(String itemId, int quantity) async {
    final response = await HttpHelper.put('/cart/$itemId', body: {
      'quantity': quantity,
    });
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }

  Future<CartModel> removeFromCart(String itemId) async {
    final response = await HttpHelper.delete('/cart/$itemId');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }
}