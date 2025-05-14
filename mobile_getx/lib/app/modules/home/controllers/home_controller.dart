import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/category/controllers/category_controller.dart';
import 'package:mobile_getx/app/modules/product/controllers/product_controller.dart';

class HomeController extends GetxController {
  final categories =
      Get.put<CategoryController>(CategoryController()).categories;
  final products = Get.put<ProductController>(ProductController()).products;

}
