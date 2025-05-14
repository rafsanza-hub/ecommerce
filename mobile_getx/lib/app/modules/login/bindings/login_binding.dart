import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/home/controllers/home_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
