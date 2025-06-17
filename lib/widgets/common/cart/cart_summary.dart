import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/checkout.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class CartSummary extends StatelessWidget {
  final List<Map<String, dynamic>> cartProducts;
  final List<int> quantities;

  const CartSummary({
    super.key,
    required this.cartProducts,
    required this.quantities,
  });

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;
    int deliveryCharges = 0;
    int totalQuantity = 0;

    for (int i = 0; i < cartProducts.length; i++) {
      final product = cartProducts[i];
      final qty = quantities[i];
      final int price = product['price'] ?? 0;
      final int delivery = product['deliveryCharges'] ?? 0;

      totalPrice += price * qty;
      deliveryCharges += delivery;
      totalQuantity += qty;
    }

    final int grandTotal = totalPrice + deliveryCharges;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow("Total Items", "$totalQuantity"),
          _summaryRow("Items Total", "₹$totalPrice"),
          _summaryRow("Delivery Charges", "₹$deliveryCharges"),
          const Divider(),
          _summaryRow("Grand Total", "₹$grandTotal", isBold: true),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColour.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Checkout(
                          cartProducts: cartProducts,
                          quantities: quantities,
                        ),
                  ),
                );
              },
              child: const Text(
                "Proceed To Checkout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
