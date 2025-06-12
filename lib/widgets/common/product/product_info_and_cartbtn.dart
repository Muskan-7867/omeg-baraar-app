// product_info_and_cartbtn.dart
import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class ProductInfoAndCartbtn extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool inCart;
  final VoidCallback onToggleCart;

  const ProductInfoAndCartbtn({
    super.key,
    required this.product,
    required this.inCart,
    required this.onToggleCart,
  });

  @override
  Widget build(BuildContext context) {
    final String name = product['name'] ?? 'No name';
    final int price = product['price'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '₹$price',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: inCart ? Colors.grey[300] : AppColour.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 16,
                onPressed: onToggleCart,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
