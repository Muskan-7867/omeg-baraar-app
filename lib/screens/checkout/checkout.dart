import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/address_section.dart';
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
  late int totalQuantity;
  Map<String, dynamic>? selectedAddress;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _calculateTotals() {
    totalPrice = 0;
    deliveryCharges = 0;
    totalQuantity = 0;

    for (int i = 0; i < widget.cartProducts.length; i++) {
      final product = widget.cartProducts[i];
      final qty = widget.quantities[i];
      final int price = product['price'] ?? 0;
      final int delivery = product['deliveryCharges'] ?? 0;

      totalPrice += price * qty;
      deliveryCharges += delivery;
      totalQuantity += qty;
    }
    grandTotal = totalPrice + deliveryCharges;
  }

  Future<void> _navigateToAddressForm() async {
    final result = await Navigator.pushNamed(context, '/addressform');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedAddress = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
            child: Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          AddressSection(
            selectedAddress: selectedAddress,
            onAddOrChangeAddress: _navigateToAddressForm,
          ),
          const SizedBox(height: 20),
          const Divider(),
          Expanded(
            child: OrderList(
              cartProducts: widget.cartProducts,
              quantities: widget.quantities,
              selectedAddress: selectedAddress,
            ),
          ),
        ],
      ),
    );
  }
}
