import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/category/bloc/category_state.dart';
import 'package:mobile/features/category/service/category_service.dart';
import '../bloc/category_bloc.dart';
import '../model/category_model.dart';
import '../../product/screens/product_list_screen.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryBloc(categoryService: context.read<CategoryService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Categories')),
        body: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              return _buildCategoryList(context, state.categories);
            } else {
              return const Center(child: Text('No categories available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<CategoryModel> categories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(category.name),
            subtitle: Text(category.description.length > 50
                ? '${category.description.substring(0, 50)}...'
                : category.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(categoryId: category.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}