import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/cart/bloc/cart_event.dart';
import 'package:mobile/features/product/bloc/product_state.dart';
import 'package:mobile/features/product/service/product_service.dart';
import '../bloc/product_bloc.dart';
import '../model/product_model.dart';
import '../../cart/bloc/cart_bloc.dart';

class ProductListScreen extends StatelessWidget {
  final String? categoryId;

  const ProductListScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(productService: context.read<ProductService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = categoryId != null
                  ? state.products.where((p) => p.categoryId == categoryId).toList()
                  : state.products;
              return _buildProductList(context, products);
            } else {
              return const Center(child: Text('No products available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<ProductModel> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: product.imageUrl.isNotEmpty
                ? Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported, size: 50),
            title: Text(product.name),
            subtitle: Text(product.description.length > 50
                ? '${product.description.substring(0, 50)}...'
                : product.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Rp ${product.price.toString()}'),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCart(product.id, 1));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}