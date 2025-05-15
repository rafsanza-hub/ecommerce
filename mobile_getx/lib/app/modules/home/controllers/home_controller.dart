import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get/get.dart';
import 'package:mobile_getx/app/data/models/category.dart';
import 'package:mobile_getx/app/data/models/product.dart';
import 'package:mobile_getx/app/modules/cart/controllers/cart_controller.dart';
import 'package:mobile_getx/app/modules/category/controllers/category_controller.dart';
import 'package:mobile_getx/app/modules/home/views/home_view.dart';
import 'package:mobile_getx/app/modules/product/controllers/product_controller.dart';
import 'package:mobile_getx/app/modules/shopping/shopping_constants.dart';
import 'package:mobile_getx/app/modules/shopping/views/notification_screen.dart';
import 'package:mobile_getx/app/modules/shopping/views/subscription_screen.dart';

class HomeController extends GetxController {
  final TickerProvider ticker;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final List<Widget> newCategories = [];
  late final CategoryController categoryController;
  late final ProductController productController;
  late final CartController cartController;
  late Category selectedCategory;
  late AnimationController animationController;
  late AnimationController bellController;
  late Animation<double> fadeAnimation;
  late Animation<double> bellAnimation;
  late Tween<Offset> offset;
  late Intro intro;

  HomeController(this.ticker) {
    _initializeControllers();
    _setupAnimations();
    _setupIntro();
  }

  void _initializeControllers() {
    categoryController = Get.put(CategoryController());
    productController = Get.put(ProductController());
    cartController = Get.put(CartController());
  }

  void _setupAnimations() {
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: ticker,
    );
    bellController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: ticker,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );
    bellAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: bellController, curve: Curves.linear),
    );
    offset = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
    animationController.forward();
    bellController.repeat(reverse: true);
  }

  void _setupIntro() {
    intro = Intro(
      stepCount: 3,
      maskClosable: true,
      onHighlightWidgetTap: (introStatus) {},
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          'Get your notifications from here',
          'Get latest & trending products here',
          'Get category-wise products here',
        ],
        buttonTextBuilder: (currPage, totalPage) {
          return currPage < totalPage - 1 ? 'Next' : 'Finish';
        },
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Initialization moved to constructor to ensure all fields are ready
  }

  @override
  void onReady() {
    super.onReady();
    intro.setStepConfig(0, borderRadius: BorderRadius.circular(64));
  }

  void startIntro(BuildContext context) {
    if (ShoppingCache.isFirstTime) {
      intro.start(context);
      ShoppingCache.isFirstTime = false;
    }
  }

  Future<bool> onWillPop() async {
    final introStatus = intro.getStatus();
    if (introStatus.isOpen) {
      intro.dispose();
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    bellController.dispose();
    super.dispose();
  }

  void changeSelectedCategory(Category category) {
    selectedCategory = category;
    update();
  }

  void goToSingleProduct(Product product) {
    Get.to(() => HomeView(), duration: const Duration(milliseconds: 500));
  }

  void goToSubscription() {
    Get.to(() => const SubscriptionScreen());
  }

  void goToNotification() {
    Get.to(() => const NotificationScreen());
  }
}
