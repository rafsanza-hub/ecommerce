import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/auth_services.dart';

class RegisterController extends GetxController {
  final AuthService authService = AuthService();

  final formKey = GlobalKey<FormState>();
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final fullNameC = TextEditingController();
  final phoneC = TextEditingController();

  final isLoading = false.obs;

  Future<void> register() async {
    isLoading.value = true;

    try {
      await authService.register(
        username: usernameC.text,
        email: emailC.text,
        password: passwordC.text,
        fullName: fullNameC.text,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
