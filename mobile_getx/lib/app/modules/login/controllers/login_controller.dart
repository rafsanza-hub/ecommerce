import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/auth_services.dart';
import 'package:mobile_getx/app/modules/register/views/register_view.dart';
import 'package:mobile_getx/app/modules/shopping/views/register_screen.dart';

class LoginController extends GetxController {
  TickerProvider ticker;
  LoginController(this.ticker);

  GlobalKey<FormState> formKey = GlobalKey();
  late AnimationController arrowController, emailController, passwordController;
  late Animation<Offset> arrowAnimation, emailAnimation, passwordAnimation;
  int emailCounter = 0;
  int passwordCounter = 0;
  final _authService = AuthService();

  final usernameOrEmailTE = TextEditingController();
  final passwordTE = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    arrowController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 500));
    emailController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 50));
    passwordController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 50));

    arrowAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(8, 0))
        .animate(CurvedAnimation(
      parent: arrowController,
      curve: Curves.easeIn,
    ));
    emailAnimation =
        Tween<Offset>(begin: Offset(-0.01, 0), end: Offset(0.01, 0))
            .animate(CurvedAnimation(
      parent: emailController,
      curve: Curves.easeIn,
    ));
    passwordAnimation =
        Tween<Offset>(begin: Offset(-0.01, 0), end: Offset(0.01, 0))
            .animate(CurvedAnimation(
      parent: passwordController,
      curve: Curves.easeIn,
    ));

    emailController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        emailController.reverse();
      }
      if (status == AnimationStatus.dismissed && emailCounter < 2) {
        emailController.forward();
        emailCounter++;
      }
    });

    passwordController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        passwordController.reverse();
      }
      if (status == AnimationStatus.dismissed && passwordCounter < 2) {
        passwordController.forward();
        passwordCounter++;
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    arrowController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      emailController.forward();
      return "Please enter email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      passwordController.forward();

      return "Please enter password";
    }
    return null;
  }

  void goToForgotPasswordScreen() {
    Get.off(RegisterView());
  }

  Future<void> login() async {
    emailCounter = 0;
    passwordCounter = 0;

    isLoading(true);
    try {
      await _authService.login(
        usernameOrEmailTE.value.text,
        passwordTE.value.text,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void goToRegisterScreen() {
    Get.off(RegisterView());
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }
}
