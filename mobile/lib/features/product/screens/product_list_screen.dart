import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/product/bloc/product_state.dart';
import 'package:mobile/features/product/service/product_service.dart';
import '../bloc/product_bloc.dart';
import '../model/product_model.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

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
              return _buildProductList(state.products);
            } else {
              return const Center(child: Text('No products available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
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
            trailing: Text('Rp ${product.price.toString()}'),
            onTap: () {
              // Opsional: Navigasi ke detail produk
              // Navigator.pushNamed(context, '/product_detail', arguments: product.id);
            },
          ),
        );
      },
    );
  }
}