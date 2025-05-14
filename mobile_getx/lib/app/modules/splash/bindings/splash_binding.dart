import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/home/bindings/home_binding.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeBinding>(
      () => HomeBinding(),
    );
  }
}
