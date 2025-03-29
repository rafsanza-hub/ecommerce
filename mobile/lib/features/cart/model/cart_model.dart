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
      id: json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, items, total];
}

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}