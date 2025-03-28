import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class FetchCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final int quantity;
  const AddToCart(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateCartItem extends CartEvent {
  final String itemId;
  final int quantity;
  const UpdateCartItem(this.itemId, this.quantity);
  @override
  List<Object?> get props => [itemId, quantity];
}

class RemoveFromCart extends CartEvent {
  final String itemId;
  const RemoveFromCart(this.itemId);
  @override
  List<Object?> get props => [itemId];
}