import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/category_service.dart';
import 'package:mobile_getx/app/data/models/product.dart';

class ProductController extends GetxController {
  final apiService = CategoryService();

  final products = <Product>[].obs;

  Future<void> getProducts() async {
    try {
      products.value = await apiService.getProducts();
    } catch (e) {
      print('Error fetching products: $e');

      Get.snackbar('Error', 'Failed to fetch products: $e');
      rethrow;
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final product = await apiService.getProductById(id);
      return product;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onInit() {
    getProducts();
    super.onInit();
  }
}
