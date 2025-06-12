import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/loaders/ProductCardShimmer.dart';
import 'package:omeg_bazaar/widgets/common/product/product_card.dart';

class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final bool isLoading;
  final String errorMessage;

  const ProductList({
    super.key,
    required this.products,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          isLoading
              ? const ProductCardShimmer()
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
    );
  }
}
