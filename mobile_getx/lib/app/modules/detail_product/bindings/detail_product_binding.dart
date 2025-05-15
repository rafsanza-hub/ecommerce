import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/product/controllers/product_controller.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
  }
}
