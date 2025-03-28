import 'package:mobile/core/helpers/http_helper.dart';
import '../model/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    final response = await HttpHelper.get('/products');
    print(response.body);
    final data = await HttpHelper.handleListResponse(
      response: response,
      fromJson: (json) =>
          json.map((item) => ProductModel.fromJson(item)).toList(),
    );
    print(data);
    return data;
  }

  Future<ProductModel> getProductById(String id) async {
    final response = await HttpHelper.get('/products/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: ProductModel.fromJson,
    );
  }
}
