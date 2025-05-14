import 'package:mobile_getx/app/modules/login/controllers/login_controller.dart';
import 'package:mobile_getx/app/core/theme/app_theme.dart';
import 'package:mobile_getx/app/core/widgets/my_button.dart';
import 'package:mobile_getx/app/core/widgets/my_container.dart';
import 'package:mobile_getx/app/core/widgets/my_spacing.dart';
import 'package:mobile_getx/app/core/widgets/my_text.dart';
import 'package:mobile_getx/app/core/widgets/my_text_style.dart';
import 'package:mobile_getx/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  late ThemeData theme;
  late LoginController controller;
  late OutlineInputBorder outlineInputBorder;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingTheme;

    controller = LoginController(this);
    outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: controller,
        tag: 'log_in_controller',
        builder: (controller) {
          return Scaffold(
            body: ListView(
              padding: MySpacing.fromLTRB(
                  20, MySpacing.safeAreaTop(context) + 64, 20, 20),
              children: [
                MyText.displaySmall(
                  'Hello aAgain!',
                  fontWeight: 700,
                  textAlign: TextAlign.center,
                ),
                MySpacing.height(20),
                MyText.bodyMedium(
                  'Welcome back you\'ve been missed!',
                  muted: true,
                  textAlign: TextAlign.center,
                ),
                MySpacing.height(32),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      SlideTransition(
                        position: controller.emailAnimation,
                        child: TextFormField(
                          style: MyTextStyle.bodyMedium(),
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              isDense: true,
                              fillColor: theme.cardTheme.color,
                              prefixIcon: Icon(
                                LucideIcons.mail,
                                color: theme.colorScheme.onBackground,
                              ),
                              hintText: "Email Address",
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                              contentPadding: MySpacing.all(16),
                              hintStyle: MyTextStyle.bodyMedium(),
                              isCollapsed: true),
                          maxLines: 1,
                          controller: controller.usernameOrEmailTE,
                          validator: controller.validateEmail,
                          cursorColor: theme.colorScheme.onBackground,
                        ),
                      ),
                      MySpacing.height(20),
                      SlideTransition(
                        position: controller.passwordAnimation,
                        child: TextFormField(
                          style: MyTextStyle.bodyMedium(),
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              isDense: true,
                              fillColor: theme.cardTheme.color,
                              prefixIcon: Icon(
                                LucideIcons.lock,
                                color: theme.colorScheme.onBackground,
                              ),
                              hintText: "Password",
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                              contentPadding: MySpacing.all(16),
                              hintStyle: MyTextStyle.bodyMedium(),
                              isCollapsed: true),
                          maxLines: 1,
                          controller: controller.passwordTE,
                          validator: controller.validatePassword,
                          cursorColor: theme.colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                MySpacing.height(20),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyButton.text(
                    onPressed: () {
                      controller.goToForgotPasswordScreen();
                    },
                    padding: MySpacing.zero,
                    splashColor: theme.colorScheme.primary.withAlpha(40),
                    child: Text(
                      "Forgot Password ?",
                      style: MyTextStyle.bodySmall(
                          color: theme.colorScheme.primary),
                    ),
                  ),
                ),
                MySpacing.height(20),
                MyButton.block(
                  elevation: 0,
                  borderRadiusAll: 4,
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.login();
                    }
                    return;
                  },
                  padding: MySpacing.y(20),
                  splashColor: theme.colorScheme.onPrimary.withAlpha(28),
                  backgroundColor: theme.colorScheme.primary,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText.labelLarge(
                          "Sign In",
                          fontWeight: 600,
                          color: theme.colorScheme.onPrimary,
                          letterSpacing: 0.4,
                        ),
                        MySpacing.width(8),
                        SlideTransition(
                            position: controller.arrowAnimation,
                            child: Icon(
                              LucideIcons.arrowRight,
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            )),
                      ],
                    ),
                  ),
                ),
                MySpacing.height(20),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: MySpacing.x(16),
                      child: MyText.bodySmall(
                        'Continue with',
                        muted: true,
                        fontSize: 10,
                        fontWeight: 600,
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                MySpacing.height(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyContainer.bordered(
                      padding: MySpacing.all(16),
                      borderRadiusAll: 4,
                      child: Image(
                        height: 20,
                        width: 20,
                        image: AssetImage(Images.google),
                      ),
                    ),
                    MyContainer.bordered(
                      padding: MySpacing.all(16),
                      borderRadiusAll: 4,
                      child: Image(
                        height: 20,
                        width: 20,
                        image: AssetImage(Images.apple),
                      ),
                    ),
                    MyContainer.bordered(
                      padding: MySpacing.all(16),
                      borderRadiusAll: 4,
                      child: Image(
                        height: 20,
                        width: 20,
                        image: AssetImage(Images.facebook),
                      ),
                    ),
                  ],
                ),
                MySpacing.height(20),
                Center(
                  child: MyButton.text(
                      padding: MySpacing.zero,
                      onPressed: () {
                        controller.goToRegisterScreen();
                      },
                      child: MyText.labelLarge("Create an Account",
                          decoration: TextDecoration.underline,
                          color: theme.colorScheme.primary)),
                ),
              ],
            ),
          );
        });
  }
}
