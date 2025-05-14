import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/auth_services.dart';
import 'package:mobile_getx/app/modules/login/views/login_view.dart';

class RegisterController extends GetxController {
  final AuthService authService = AuthService();

  final isLoading = false.obs;
  TickerProvider ticker;
  RegisterController(this.ticker);
  GlobalKey<FormState> formKey = GlobalKey();
  late AnimationController arrowController,
      nameController,
      emailController,
      passwordController;
  late Animation<Offset> arrowAnimation,
      nameAnimation,
      emailAnimation,
      passwordAnimation;
  int nameCounter = 0;
  int emailCounter = 0;
  int passwordCounter = 0;
  final usernameC = TextEditingController();
  final emailTE = TextEditingController();
  final passwordTE = TextEditingController();
  final confirmPasswordTE = TextEditingController();
  final fullNameTE = TextEditingController();
  final phoneTE = TextEditingController();

  @override
  void onInit() {
    arrowController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 500));
    nameController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 50));
    emailController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 50));
    passwordController = AnimationController(
        vsync: ticker, duration: Duration(milliseconds: 50));

    arrowAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(8, 0))
        .animate(CurvedAnimation(
      parent: arrowController,
      curve: Curves.easeIn,
    ));
    nameAnimation = Tween<Offset>(begin: Offset(-0.01, 0), end: Offset(0.01, 0))
        .animate(CurvedAnimation(
      parent: nameController,
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

    nameController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nameController.reverse();
      }
      if (status == AnimationStatus.dismissed && nameCounter < 2) {
        nameController.forward();
        nameCounter++;
      }
    });
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

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      emailController.forward();
      return "Please enter email";
    }
    if (GetUtils.isEmail(text)) {
      emailController.forward();
      return "Please enter valid email";
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

  String? validatePhone(String? text) {
    if (text == null || text.isEmpty) {
      passwordController.forward();

      return "Please enter phone";
    }
    return null;
  }

  String? validateName(String? text) {
    if (text == null || text.isEmpty) {
      nameController.forward();
      return "Please enter name";
    }
    return null;
  }

  @override
  void dispose() {
    arrowController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    passwordCounter = 0;
    nameCounter = 0;
    emailCounter = 0;
    isLoading.value = true;

    if (!formKey.currentState!.validate()) {
      isLoading.value = false;
      return;
    }
    try {
      await authService.register(
        username: usernameC.text,
        email: emailTE.text,
        password: passwordTE.text,
        fullName: fullNameTE.text,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogInScreen() {
    Get.off(LoginView());
  }
}
