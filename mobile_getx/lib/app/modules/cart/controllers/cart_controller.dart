import 'package:get/get.dart';
import 'package:mobile_getx/app/data/models/cart.dart';
import 'package:mobile_getx/app/data/services/category_service.dart';
import 'package:mobile_getx/app/modules/order/controllers/order_controller.dart';

class CartController extends GetxController {
  final _cartService = CategoryService();
  final OrderController orderController =
      Get.put<OrderController>(OrderController());

  final cartItems = <CartItem>[].obs;
  final itemCount = 0.obs;
  final isLoading = false.obs;

  Future<void> getCart() async {
    isLoading.value = true;
    try {
      final cart = await _cartService.getCart();
      cartItems.value = cart.items;
      itemCount.value = cart.total;
    } catch (e) {
      print('Error fetching cart: $e');
      Get.snackbar('Error', 'Failed to fetch cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    isLoading.value = true;
    print('Adding to carst: $productId, quantity: $quantity');
    try {
      final cart = await _cartService.addToCart(productId, quantity);
      getCart();
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar('Error', 'Failed to add item to cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCartItem(String itemId, int quantity) async {
    isLoading.value = true;
    try {
      final cart = await _cartService.updateCartItem(itemId, quantity);
      cartItems.value = cart.items;
      itemCount.value = cart.total;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update cart item: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(String itemId) async {
    isLoading.value = true;
    try {
      final cart = await _cartService.removeFromCart(itemId);
      cartItems.value = cart.items;
      itemCount.value = cart.total;
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item from cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    getCart();
    super.onInit();
  }
}
