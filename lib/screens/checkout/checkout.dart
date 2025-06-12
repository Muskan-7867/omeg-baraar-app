import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/order_list.dart';

class Checkout extends StatefulWidget {
  final List<Map<String, dynamic>> cartProducts;
  final List<int> quantities;
  const Checkout({
    super.key,
    required this.cartProducts,
    required this.quantities,
  });

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late int totalPrice;
  late int deliveryCharges;
  late int grandTotal;
  late int totalQunatity;

  @override
  void initState() {
    super.initState();
    totalPrice = 0;
    deliveryCharges = 0;
    grandTotal = 0;
    totalQunatity = 0;

    for (int i = 0; i < widget.cartProducts.length; i++) {
      final product = widget.cartProducts[i];
      final qty = widget.quantities[i];
      final int price = product['price'] ?? 0;
      final int delivery = product['deliveryCharges'] ?? 0;

      totalPrice += price * qty;
      deliveryCharges += delivery;
      totalQunatity += qty;
    }
    grandTotal = totalPrice + deliveryCharges;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 0, 0),
                child: Icon(Icons.location_on, size: 42, color: Colors.grey),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(54, 0, 26, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 2,
              children: [
                Text('John Doe', style: TextStyle(fontSize: 14)),
                Text('123 Main St', style: TextStyle(fontSize: 14)),
                Text(
                  'Apt 4B gfht gghf fhfhh fh',
                  style: TextStyle(fontSize: 12),
                ),
                Text('New York, NY 10001', style: TextStyle(fontSize: 14)),
                Text('New York, NY 10001', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(),
          //order list
          Expanded(
            child: OrderList(
              cartProducts: widget.cartProducts,
              quantities: widget.quantities,
            ),
          ),
        ],
      ),
    );
  }
}
