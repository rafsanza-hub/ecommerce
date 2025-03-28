import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/product_service.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc({required this.productService}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchProductById>(_onFetchProductById);

    add(FetchProducts()); // Auto-fetch saat inisialisasi
  }

  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productService.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchProductById(FetchProductById event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final product = await productService.getProductById(event.id);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}