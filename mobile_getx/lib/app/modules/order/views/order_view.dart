import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderView'),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final order = controller.orders[index];

                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/order/${order.id}');
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${order.id}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Status: ${order.status}'),
                          Text('Total: Rp ${order.total.toString()}'),
                          Text('Date: ${order.createdAt.toLocal()}'),
                          const Divider(),
                          const Text('Items:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...order.items.map((item) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(item.product.name)),
                                  Text('x${item.quantity}'),
                                  Text('Rp ${item.product.price}'),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ]),
    );
  }
}
