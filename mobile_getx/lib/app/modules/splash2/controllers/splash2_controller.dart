import 'package:mobile_getx/app/modules/main/views/main_view.dart';
import 'package:mobile_getx/app/modules/shopping/models/cart.dart';
import 'package:mobile_getx/app/modules/shopping/models/category.dart';
import 'package:mobile_getx/app/modules/shopping/models/product.dart';
import 'package:mobile_getx/app/modules/shopping/shopping_constants.dart';
import 'package:mobile_getx/app/modules/shopping/views/full_app.dart';
import 'package:get/get.dart';

class Splash2Controller extends GetxController {
  @override
  void onInit() {
    goToFullApp();
    super.onInit();
  }

  goToFullApp() async {
    ShoppingCache.products = await Product.getDummyList();
    ShoppingCache.categories = await Category.getDummyList();
    ShoppingCache.carts = await Cart.getDummyList();
    await Future.delayed(Duration(seconds: 1));

    Get.off(MainView());
  }
}
