import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/checkout/summary_row.dart';

class OrderSummary extends StatelessWidget {
  final List<dynamic> cartProducts;
  final List<int> quantities;
  final bool isBuyNow;

  const OrderSummary({
    super.key,
    required this.cartProducts,
    required this.quantities,
    required this.isBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    double itemsTotal = 0;
    double deliveryCharges = 0;

    for (int i = 0; i < cartProducts.length; i++) {
      final product = cartProducts[i];
      final qty = quantities[i];
      final double price = product['price']?.toDouble() ?? 0;
      final double delivery = product['deliveryCharges']?.toDouble() ?? 0;

      itemsTotal += price * qty;
      deliveryCharges += delivery;
    }

    double averageDeliveryCharges =
        cartProducts.isNotEmpty ? deliveryCharges / cartProducts.length : 0;

    double grandTotal = itemsTotal + averageDeliveryCharges;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 58),
      child: Column(
        children: [
          SummaryRow(label: 'Items Total', value: itemsTotal),
          SummaryRow(label: 'Delivery Charges', value: averageDeliveryCharges),
          const Divider(),
          SummaryRow(label: 'Grand Total', value: grandTotal, isBold: true),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
