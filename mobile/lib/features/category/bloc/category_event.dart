import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchCategories extends CategoryEvent {}

class FetchCategoryById extends CategoryEvent {
  final String id;
  const FetchCategoryById(this.id);
  @override
  List<Object?> get props => [id];
}