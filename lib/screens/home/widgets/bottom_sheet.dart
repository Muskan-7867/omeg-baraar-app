import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/cart/cart_summary.dart';

class BottomSheetCart extends StatelessWidget {
  final List<Map<String, dynamic>> cartProducts;
  final List<int> quantities;

  const BottomSheetCart({
    super.key,
    required this.cartProducts,
    required this.quantities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 340,
      width: double.infinity,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: CartSummary(
                cartProducts: cartProducts,
                quantities: quantities,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
