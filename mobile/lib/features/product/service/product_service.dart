import 'package:mobile/core/helpers/http_helper.dart';
import '../model/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    final response = await HttpHelper.get('/products');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: (json) => (json as List).map((item) => ProductModel.fromJson(item)).toList(),
    );
  }

  Future<ProductModel> getProductById(String id) async {
    final response = await HttpHelper.get('/products/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: ProductModel.fromJson,
    );
  }
}