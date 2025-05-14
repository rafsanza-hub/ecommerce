import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_getx/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return ListTile(
                  title: Text(category.name),
                );
              },
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return ListTile(
                  title: Text(product.name),
                  trailing: IconButton(
                      onPressed: () {
                        print('Adding ${product.id} to cart');
                        controller.cartController.addToCart(product.id, 1);
                        Get.snackbar(
                          'Product Added',
                          '${product.name} has been added to your cart',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                        );
                      },
                      icon: Icon(Icons.add)),
                );
              },
            );
          }),
        ),
        ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.CART);
            },
            child: Text('Cart')),
      ]),
    );
  }
}
