import 'package:mobile/core/helpers/http_helper.dart';
import '../model/cart_model.dart';
import 'package:flutter/foundation.dart';

class CartService {
  Future<CartModel> getCart() async {
    final response = await HttpHelper.get('/cart');
    if (kDebugMode) print('GetCart Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }

  Future<CartModel> addToCart(String productId, int quantity) async {
    final response = await HttpHelper.post('/cart/item', body: {
      'productId': productId,
      'quantity': quantity,
    });
    if (kDebugMode) print('AddToCart Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }

  Future<CartModel> updateCartItem(String itemId, int quantity) async {
    final response = await HttpHelper.put('/cart/$itemId', body: {
      'quantity': quantity,
    });
    if (kDebugMode) print('UpdateCartItem Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }

  Future<CartModel> removeFromCart(String itemId) async {
    final response = await HttpHelper.delete('/cart/$itemId');
    if (kDebugMode) print('RemoveFromCart Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CartModel.fromJson,
    );
  }
}