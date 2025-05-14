import 'package:equatable/equatable.dart';
import '../models/product.dart';

class Cart extends Equatable {
  final String id;
  final List<CartItem> items;
  final int total;

  const Cart({
    required this.id,
    required this.items,
    required this.total,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
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
  final Product product; 
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
