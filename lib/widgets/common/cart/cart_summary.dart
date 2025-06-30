// cart_summary.dart
import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/checkout.dart';
import 'package:omeg_bazaar/services/order/cart_products_order_api.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class CartSummary extends StatelessWidget {
  final List<Map<String, dynamic>> cartProducts;
  final List<int> quantities;
  final String token;
  final Map<String, dynamic>? address;
  final String paymentMethod;

  const CartSummary({
    super.key,
    required this.cartProducts,
    required this.quantities,
    required this.token,
    required this.address,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;
    int deliveryCharges = 0;
    int totalQuantity = 0;
    int itemCount = cartProducts.length;

    for (int i = 0; i < cartProducts.length; i++) {
      final product = cartProducts[i];
      final qty = quantities[i];
      final int price = product['price'] ?? 0;
      final int delivery = product['deliveryCharges'] ?? 0;

      totalPrice += price * qty;
      deliveryCharges += delivery;
      totalQuantity += qty;
    }

    int averageDeliveryCharges =
        itemCount > 0 ? (deliveryCharges / itemCount).round() : 0;

    final int grandTotal = totalPrice + averageDeliveryCharges;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow("Total Items", "$totalQuantity"),
          _summaryRow("Items Total", "₹$totalPrice"),
          _summaryRow("Delivery Charges (Avg)", "₹$averageDeliveryCharges"),
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
              onPressed: () async {
                if (address == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please set your address')),
                  );
                  return;
                }
                try {
                  // Prepare data for API call
                  final cartProductIds =
                      cartProducts.map((p) => p['_id'].toString()).toList();

                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) =>
                            const Center(child: CircularProgressIndicator()),
                  );

                  // Call the API
                  final response =
                      await CartProductsOrderApi.createRazorPayOrderOfCart(
                        cartProductIds: cartProductIds,
                        address: address,
                        quantities: quantities,
                        paymentMethod: paymentMethod,
                        token: token,
                      );

                  // Close loading indicator
                  Navigator.of(context).pop();

                  // Navigate to checkout with the response
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
                } catch (e) {
                  // Close loading indicator if still showing
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }

                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
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
