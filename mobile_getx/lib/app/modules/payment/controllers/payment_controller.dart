import 'package:get/get.dart';
import 'package:mobile_getx/app/data/services/category_service.dart';

class PaymentController extends GetxController {
  final _paymentService = CategoryService();
  final isLoading = false.obs;
  final paymentMethod = ''.obs;
  final orderId = Get.arguments;
  final amount = 0.0.obs;

  Future<void> createPayment() async {
    isLoading.value = true;

    try {
      final payment = await _paymentService.createPayment(
        orderId,
        paymentMethod.value,
      );
    } catch (e) {
      print('Error creating payment: $e');
      Get.snackbar('Error', 'Failed to create payment: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
