import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/shopping/views/home_screen.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreen>(
      () => HomeScreen(),
    );
  }
}
