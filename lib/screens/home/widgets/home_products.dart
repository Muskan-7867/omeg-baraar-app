import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/loaders/product_card_shimmer.dart';
import 'package:omeg_bazaar/widgets/common/product/product_card.dart';
import 'package:omeg_bazaar/widgets/common/title.dart';

class ProductsOnHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> displayedProducts;
  final bool isLoading;
  final String selectedCategory;
  final VoidCallback onSeeAllPressed;

  const ProductsOnHomePage({
    super.key,
    required this.displayedProducts,
    required this.isLoading,
    required this.selectedCategory,
    required this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title:
              selectedCategory.isEmpty
                  ? 'Top Picks for You'
                  : 'Products in "$selectedCategory"',
          onSeeAll: onSeeAllPressed,
        ),
        const SizedBox(height: 10),
        isLoading
            ? const ProductCardShimmer()
            : displayedProducts.isEmpty
            ? const Center(child: Text("No products found."))
            : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedProducts.length,
              padding: const EdgeInsets.only(top: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: displayedProducts[index]);
              },
            ),
      ],
    );
  }
}
