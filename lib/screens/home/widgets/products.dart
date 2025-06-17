import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/loaders/product_card_shimmer.dart';
import 'package:omeg_bazaar/widgets/common/product/product_card.dart';

class Products extends StatelessWidget {
  final List products;
  final bool isLoading;

  const Products({super.key, required this.products, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child:
          isLoading
              ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return const ProductCardShimmer();
                },
              )
              : products.isEmpty
              ? const Center(child: Text("No products found."))
              : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
    );
  }
}
