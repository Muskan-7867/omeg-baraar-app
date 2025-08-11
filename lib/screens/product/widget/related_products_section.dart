import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/product/product_card.dart';

class RelatedProducts extends StatelessWidget {
  final List<dynamic> products;
  final bool isSmallScreen;
  final Function(dynamic)? onProductTap; // Add this callback

  const RelatedProducts({
    super.key,
    required this.products,
    this.isSmallScreen = false,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Related Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isSmallScreen ? 2 : 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => onProductTap?.call(product),
              child: ProductCard(
                product: product,
                isSmallScreen: isSmallScreen,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
