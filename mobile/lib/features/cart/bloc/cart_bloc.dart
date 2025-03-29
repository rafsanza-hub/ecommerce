import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/cart_service.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:flutter/foundation.dart'; // Untuk kDebugMode

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService cartService;

  CartBloc({required this.cartService}) : super(CartInitial()) {
    on<FetchCart>(_onFetchCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<RemoveFromCart>(_onRemoveFromCart);

    add(FetchCart());
  }

  Future<void> _onFetchCart(FetchCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await cartService.getCart();
      emit(CartLoaded(cart));
    } catch (e) {
      if (kDebugMode) print('FetchCart Error: $e');
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await cartService.addToCart(event.productId, event.quantity);
      emit(CartLoaded(cart));
    } catch (e) {
      if (kDebugMode) print('AddToCart Error: $e');
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await cartService.updateCartItem(event.itemId, event.quantity);
      emit(CartLoaded(cart));
    } catch (e) {
      if (kDebugMode) print('UpdateCartItem Error: $e');
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await cartService.removeFromCart(event.itemId);
      emit(CartLoaded(cart));
    } catch (e) {
      if (kDebugMode) print('RemoveFromCart Error: $e');
      emit(CartError(e.toString()));
    }
  }
}