import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/auth_services.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isAuthenticated = await AuthService().isAuthenticated();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: isAuthenticated ? Routes.HOME : Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}
