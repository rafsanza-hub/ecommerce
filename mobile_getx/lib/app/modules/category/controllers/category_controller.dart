import 'package:get/get.dart';
import 'package:mobile_getx/app/data/models/category.dart';
import 'package:mobile_getx/app/data/services/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final categories = <Category>[].obs;

  Future<void> getCategories() async {
    try {
      categories.value = await _categoryService.getCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    }
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      return await _categoryService.getCategoryById(id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch category: $e');
      return null;
    }
  }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }
}
