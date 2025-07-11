import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omegbazaar/widgets/common/cart/cart_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetCart extends StatelessWidget {
  final List<Map<String, dynamic>> cartProducts;
  final List<int> quantities;
  final String paymentMethod; // Added paymentMethod parameter

  const BottomSheetCart({
    super.key,
    required this.cartProducts,
    required this.quantities,
    this.paymentMethod = "online", // Default to "online" if not provided
  });

  Future<Map<String, String?>> _getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'token': prefs.getString(
          'authToken',
        ), // Make sure this key matches your storage
        'address': prefs.getString(
          'useraddress',
        ), // Make sure this key matches your storage
      };
    } catch (e) {
      // Return empty strings if there's an error
      return {'token': '', 'address': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle errors - show error message or empty container
        if (snapshot.hasError) {
          debugPrint('Error fetching user data: ${snapshot.error}');
          return Container(
            color: Colors.white,
            height: 340,
            child: const Center(child: Text('Could not load user data')),
          );
        }

        final token = snapshot.data?['token'] ?? '';
        final address = snapshot.data?['address'] ?? '';
        Map<String, dynamic>? addressMap;
        if (address.isNotEmpty) {
          try {
            addressMap = json.decode(address) as Map<String, dynamic>;
          } catch (e) {
            debugPrint('Error parsing address: $e');
          }
        }

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
                    token: token,
                    address: addressMap,
                    paymentMethod: paymentMethod, // Pass the paymentMethod
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
