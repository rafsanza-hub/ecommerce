import 'package:equatable/equatable.dart';
import '../../cart/model/cart_model.dart';
import '../../product/model/product_model.dart';

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final int total;
  final String status;
  final String? paymentStatus;
  final ShippingAddress? shippingAddress;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    this.paymentStatus,
    this.shippingAddress,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      userId: json['user'] as String? ?? json['userId'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? []).map((item) {
        final productJson = item['product'];
        // Jika product adalah string (ID saja), buat ProductModel minimal
        if (productJson is String) {
          return CartItem(
            product: ProductModel(
              id: productJson,
              name: 'Unknown', // Default sementara
              description: '',
              price: item['price'] as int? ?? 0,
              imageUrl: '',
              categoryId: '',
            ),
            quantity: item['quantity'] as int? ?? 0,
          );
        }
        // Jika product adalah object (tidak diharapkan di order), parse normal
        return CartItem.fromJson(item as Map<String, dynamic>);
      }).toList(),
      total: json['total'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['paymentStatus'] as String?,
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(json['shippingAddress'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [id, userId, items, total, status, paymentStatus, shippingAddress, createdAt];
}

class ShippingAddress extends Equatable {
  final String street;
  final String city;
  final String postalCode;
  final String country;

  const ShippingAddress({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'postalCode': postalCode,
        'country': country,
      };

  @override
  List<Object?> get props => [street, city, postalCode, country];
}