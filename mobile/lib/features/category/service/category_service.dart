import 'package:mobile/core/helpers/http_helper.dart';
import '../model/category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> getCategories() async {
    final response = await HttpHelper.get('/categories');
    return await HttpHelper.handleListResponse(
      response: response,
      fromJson: (json) => json.map((item) => CategoryModel.fromJson(item)).toList(),
    );
  }

  Future<CategoryModel> getCategoryById(String id) async {
    final response = await HttpHelper.get('/categories/$id');
    return await HttpHelper.handleResponse(
      response: response,
      fromJson: CategoryModel.fromJson,
    );
  }
}