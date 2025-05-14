import 'package:mobile_getx/app/core/helpers/http_helper.dart';
import 'package:mobile_getx/app/data/models/category.dart';
import 'package:mobile_getx/app/data/models/cart.dart';
import 'package:mobile_getx/app/data/models/order.dart';
import 'package:mobile_getx/app/data/models/product.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    final response = await HttpHelper.get('/categories');
    return await HttpHelper.handleListResponse(
      response: response,
      fromJson: (json) => json.map((item) => Category.fromJson(item)).toList(),
    );
  }

  Future<Category> getCategoryById(String id) async {
    final response = await HttpHelper.get('/categories/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: Category.fromJson,
    );
  }

  Future<List<Product>> getProducts() async {
    final response = await HttpHelper.get('/products');
    print(response.body);
    final data = await HttpHelper.handleListResponse(
      response: response,
      fromJson: (json) => json.map((item) => Product.fromJson(item)).toList(),
    );
    print(data);
    return data;
  }

  Future<Product> getProductById(String id) async {
    final response = await HttpHelper.get('/products/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: Product.fromJson,
    );
  }

  Future<Cart> getCart() async {
    final response = await HttpHelper.get('/cart');
    if (response.statusCode == 404) {
      return Cart(
        id: '',
        items: [],
        total: 0,
      );
    }
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: Cart.fromJson,
    );
  }

  Future<Cart> addToCart(String productId, int quantity) async {
    print('Adding to carts: $productId, quantity: $quantity');
    final response = await HttpHelper.post('/cart/item', body: {
      'productId': productId,
      'quantity': quantity,
    });
    print('Response: ${response.body}');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: Cart.fromJson,
    );
  }

  Future<Cart> updateCartItem(String itemId, int quantity) async {
    final response = await HttpHelper.put('/cart/$itemId', body: {
      'quantity': quantity,
    });
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: Cart.fromJson,
    );
  }

  Future<Cart> removeFromCart(String itemId) async {
    final response = await HttpHelper.delete('/cart/$itemId');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: Cart.fromJson,
    );
  }

  Future<void> createOrder(ShippingAddress shippingAddress) async {
    final response = await HttpHelper.post('/orders', body: {
      'shippingAddress': shippingAddress.toJson(),
    });
    response;
  }

  Future<List<Order>> getOrders() async {
    final response = await HttpHelper.get('/orders');
    return await HttpHelper.handleListResponse<List<Order>>(
      response: response,
      fromJson: (data) {
        return data
            .map((item) => Order.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Order> getOrderById(String id) async {
    final response = await HttpHelper.get('/orders/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: Order.fromJson,
    );
  }
}
