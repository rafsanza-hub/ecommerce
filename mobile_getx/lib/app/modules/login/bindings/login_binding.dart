import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/splash2/controllers/splash2_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Splash2Controller>(
      () => Splash2Controller(),
    );
  }
}
