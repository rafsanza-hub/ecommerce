import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final String description;
  final bool isActive;

  const Category({
    required this.id,
    required this.name,
    this.icon = 'assets/images/apps/shopping2/icons/dress_outline.png',
    required this.description,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, name, description, isActive];
}
