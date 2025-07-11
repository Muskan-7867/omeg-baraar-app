import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/home/widgets/bottom_sheet.dart';
import 'package:omegbazaar/screens/cart/widgets/cart_btn.dart';

class SingleCartProdCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String? imageUrl;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const SingleCartProdCard({
    super.key,
    required this.product,
    required this.imageUrl,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {
        showModalBottomSheet<void>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          builder: (BuildContext context) {
            return BottomSheetCart(
              cartProducts: [product],
              quantities: [quantity],
            );
          },
        );
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        imageUrl ??
                            "https://via.placeholder.com/90x90.png?text=No+Image",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? "Product Name",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "₹${product['price'] ?? '0'} /-",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              CartButton(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
