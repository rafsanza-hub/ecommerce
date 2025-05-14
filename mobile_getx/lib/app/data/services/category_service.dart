import 'package:mobile_getx/app/core/helpers/http_helper.dart';
import 'package:mobile_getx/app/data/models/category.dart';

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
}
