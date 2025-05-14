import 'package:equatable/equatable.dart';
import 'package:mobile_getx/app/data/models/cart.dart';
import 'package:mobile_getx/app/data/models/product.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final int total;
  final String status;
  final ShippingAddress? shippingAddress;
  final DateTime createdAt;
  final Payment? payment;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    this.shippingAddress,
    required this.createdAt,
    this.payment,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    return Order(
      id: json['id'] as String? ?? '',
      userId: userJson != null
          ? userJson['id'] as String? ?? ''
          : json['userId'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? []).map((item) {
        final productJson = item['product'];
        return CartItem(
          product: productJson is String
              ? Product(
                  id: productJson,
                  name: 'Unknown',
                  description: '',
                  price: item['price'] as int? ?? 0,
                  imageUrl: '',
                  categoryId: '',
                )
              : Product.fromJson(productJson as Map<String, dynamic>),
          quantity: item['quantity'] as int? ?? 0,
        );
      }).toList(),
      total: json['total'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(
              json['shippingAddress'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(
          json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      payment: json['payment'] != null
          ? Payment.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props =>
      [id, userId, items, total, status, shippingAddress, createdAt, payment];
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

class Payment extends Equatable {
  final String id;
  final String transactionId;
  final String paymentType;
  final int amount;
  final String status;

  const Payment({
    required this.id,
    required this.transactionId,
    required this.paymentType,
    required this.amount,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      paymentType: json['paymentType'] as String? ?? 'unknown',
      amount: json['amount'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
    );
  }

  @override
  List<Object?> get props => [id, transactionId, paymentType, amount, status];
}
