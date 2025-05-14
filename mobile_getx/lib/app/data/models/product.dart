import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final String categoryId;

  const Product({
    required this.id,
    required this.name,
    this.description = '', 
    required this.price,
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
  List<Object?> get props => [id, name, description, price, imageUrl, categoryId];
}