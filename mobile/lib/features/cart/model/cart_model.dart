import 'package:equatable/equatable.dart';
import '../../product/model/product_model.dart';

class CartModel extends Equatable {
  final String id;
  final List<CartItem> items;
  final int total;

  const CartModel({
    required this.id,
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      total: json['total'] as int,
    );
  }

  @override
  List<Object?> get props => [id, items, total];
}

class CartItem extends Equatable {
  final String id;
  final ProductModel product;
  final int quantity;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity];
}