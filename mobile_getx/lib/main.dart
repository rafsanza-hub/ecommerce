import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/auth_services.dart';

import 'package:mobile_getx/app/core/localizations/app_localization_delegate.dart';
import 'package:mobile_getx/app/core/localizations/language.dart';
import 'package:mobile_getx/app/core/theme/app_notifier.dart';
import 'package:mobile_getx/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile_getx/app/modules/login/views/login_view.dart';
import 'package:mobile_getx/app/modules/shopping/views/home_screen.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  final isAuthenticated = await AuthService().isAuthenticated();

  // MobileAds.instance.initialize();
  AppTheme.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: LoginView(),
        builder: (context, child) {
          return Directionality(
            textDirection: AppTheme.textDirection,
            child: child ?? Container(),
          );
        },
        localizationsDelegates: [
          AppLocalizationsDelegate(context),
          // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Language.getLocales(),
        // home: IntroScreen(),
        // home: CookifyShowcaseScreen(),
      );
    });
  }
}
