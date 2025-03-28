import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {}

class FetchProductById extends ProductEvent {
  final String id;
  const FetchProductById(this.id);
  @override
  List<Object?> get props => [id];
}