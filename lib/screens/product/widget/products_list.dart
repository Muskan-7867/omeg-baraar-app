import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/loaders/product_card_shimmer.dart';
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

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    if (screenWidth > 600) return 2;
    return 2;
  }

  double _calculateChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 0.85;
    if (screenWidth > 800) return 0.80;
    return 0.75;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Expanded(
      child: isLoading
          ? ProductCardShimmer(
              crossAxisCount: _calculateCrossAxisCount(context),
              childAspectRatio: _calculateChildAspectRatio(context),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 20,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _calculateCrossAxisCount(context),
                    crossAxisSpacing: isSmallScreen ? 10 : 15,
                    mainAxisSpacing: isSmallScreen ? 10 : 15,
                    childAspectRatio: _calculateChildAspectRatio(context),
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: products[index],
                      isSmallScreen: isSmallScreen,
                    );
                  },
                ),
    );
  }
}