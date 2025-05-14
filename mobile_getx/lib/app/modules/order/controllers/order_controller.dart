import 'package:get/get.dart';
import 'package:mobile_getx/app/data/models/order.dart';
import 'package:mobile_getx/app/data/services/category_service.dart';

class OrderController extends GetxController {
  final _orderService = CategoryService();
  final orders = <Order>[].obs;

  Future<void> getOrders() async {
    try {
      orders.value = await _orderService.getOrders();
    } catch (e) {
      print('Error fetching orders: $e');
      Get.snackbar('Error', 'Failed to fetch orders: $e');
    }
  }

  Future<void> createOrder(ShippingAddress address) async {
    try {
      await _orderService.createOrder(address);
      Get.snackbar('Success', 'Order created successfully');
      await getOrders();
    } catch (e) {
      print('Error creating order: $e');
      Get.snackbar('Error', 'Failed to create order: $e');
    }
  }

  Future<void> getOrder(String orderId) async {
    try {
      await _orderService.getOrderById(orderId);
      Get.snackbar('Success', 'Order deleted successfully');
      await getOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: $e');
    }
  }

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }
}
