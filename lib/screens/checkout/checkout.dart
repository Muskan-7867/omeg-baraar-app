import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/checkout/order_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  Map<String, dynamic>? savedAddress;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
    _loadAddress();
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

  Future<void> _loadAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressJson = prefs.getString('useraddress');

      if (addressJson != null) {
        setState(() {
          savedAddress = jsonDecode(addressJson);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load address';
      });
    }
  }

  Widget _buildAddressSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
      );
    }

    if (savedAddress == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('No address saved. Please add an address.'),
            TextButton(
              onPressed: _navigateToAddressForm,
              child: const Text('Add Address'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 16, 0, 0),
              child: Icon(Icons.location_on, size: 42, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                savedAddress!['type'] ?? 'Address',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(54, 0, 26, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (savedAddress!['name'] != null)
                Text(
                  savedAddress!['name'],
                  style: const TextStyle(fontSize: 14),
                ),
              if (savedAddress!['address'] != null)
                Text(
                  savedAddress!['address'],
                  style: const TextStyle(fontSize: 14),
                ),
              if (savedAddress!['address1'] != null &&
                  savedAddress!['address1'].isNotEmpty)
                Text(
                  savedAddress!['address1'],
                  style: const TextStyle(fontSize: 12),
                ),
              Text(
                '${savedAddress!['city'] ?? ''}, ${savedAddress!['state'] ?? ''} ${savedAddress!['pincode'] ?? ''}',
                style: const TextStyle(fontSize: 14),
              ),
              if (savedAddress!['phone'] != null)
                Text(
                  'Phone: ${savedAddress!['phone']}',
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToAddressForm() async {
    final result = await Navigator.pushNamed(context, '/addressform');
    if (result == true) {
      setState(() {
        isLoading = true;
      });
      await _loadAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Text(
                  'Shipping Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: _navigateToAddressForm,
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          _buildAddressSection(),
          const SizedBox(height: 20),
          const Divider(),
          // Order list
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
