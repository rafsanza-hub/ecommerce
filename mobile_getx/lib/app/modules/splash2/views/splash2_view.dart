import 'package:mobile_getx/app/core/theme/app_theme.dart';
import 'package:mobile_getx/app/core/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/splash2/controllers/splash2_controller.dart';

class Splash2View extends StatefulWidget {
  const Splash2View({Key? key}) : super(key: key);

  @override
  _Splash2ViewState createState() => _Splash2ViewState();
}

class _Splash2ViewState extends State<Splash2View> {
  late ThemeData theme;

  late Splash2Controller controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingTheme;

    controller = Splash2Controller();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Splash2Controller>(
        init: controller,
        tag: 'splash_screen2_controller',
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "splash_username",
                    child: MyText.titleLarge(
                      "Hey Nency,",
                      fontWeight: 700,
                    ),
                  ),
                  MyText.bodySmall(
                    "Wait here, we are fetching data",
                  ),
                ],
              ),
            ),
          );
        });
  }
}
