import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/category_service.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService categoryService;

  CategoryBloc({required this.categoryService}) : super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
    on<FetchCategoryById>(_onFetchCategoryById);

    add(FetchCategories()); // Auto-fetch saat inisialisasi
  }

  Future<void> _onFetchCategories(FetchCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await categoryService.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onFetchCategoryById(FetchCategoryById event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final category = await categoryService.getCategoryById(event.id);
      emit(CategoryDetailLoaded(category));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}