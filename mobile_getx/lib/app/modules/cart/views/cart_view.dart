import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_getx/app/data/models/order.dart';
import 'package:mobile_getx/app/routes/app_pages.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CartView'),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = controller.cartItems[index];
                return ListTile(
                  title: Text(cartItem.product.name),
                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                  trailing:
                      Text('\$${cartItem.product.price * cartItem.quantity}'),
                );
              },
            );
          }),
        ),
        Obx(() {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${controller.itemCount}'),
          );
        }),
        ElevatedButton(
            onPressed: () {
              controller.orderController.createOrder(ShippingAddress(
                street: 'cisantana',
                city: 'kuningan',
                postalCode: '45552',
                country: 'indonesia',
              ));
              Get.snackbar(
                'Order Created',
                'Your order has been created successfully',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
              );
              Get.toNamed(Routes.ORDER);
            },
            child: Text('Checkout')),
      ]),
    );
  }
}
