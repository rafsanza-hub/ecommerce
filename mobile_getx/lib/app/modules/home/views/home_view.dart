import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
                );
              },
            );
          }),
        ),
      ]),
    );
  }
}
