import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/category/controllers/category_controller.dart';
import 'package:mobile_getx/app/modules/product/controllers/product_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );
  }
}
