import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/auth_services.dart';

class LoginController extends GetxController {
  final _authService = AuthService();

  final usernameOrEmailC = TextEditingController();
  final passwordC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> login() async {
    isLoading(true);
    try {
      await _authService.login(
        usernameOrEmailC.value.text,
        passwordC.value.text,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    usernameOrEmailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
