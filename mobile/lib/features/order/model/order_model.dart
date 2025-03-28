import 'package:equatable/equatable.dart';
import '../../cart/model/cart_model.dart';

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items; // Reusing CartItem from cart
  final int total;
  final String status; // pending, confirmed, shipped, delivered, cancelled
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      total: json['total'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, userId, items, total, status, createdAt];
}