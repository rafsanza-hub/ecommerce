// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final int price;
  final int? quantity;
  final double? rating;
  final bool favorite;
  final Color? color;
  final String? image;
  final String imageUrl;
  final String categoryId;

  const Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.quantity = 0,
    this.image = "assets/images/apps/shopping2/images/photo1.jpg",
    this.rating = 0.0,
    this.favorite = true,
    this.color = Colors.blue,
    required this.imageUrl,
    this.categoryId = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Product',
      description: json['description'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      categoryId: json['category']?['id'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, price, imageUrl, categoryId];
}
