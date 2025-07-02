import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/payment-methods/method_dropdown.dart';
import 'package:omeg_bazaar/screens/profile/user_profile.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children left
            children: [
              const Text(
                'Credit & Debit Card',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PaymentMethodDropdown(
                icon: Icons.credit_card,
                title: 'Add New Card',
                onTap: () {},
              ),
              const Text(
                'More Payment Options',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              PaymentMethodDropdown(
                icon: Icons.payments,
                title: 'Add New Card',
                onTap: () {},
              ),
              PaymentMethodDropdown(
                icon: Icons.account_circle,
                title: 'Add New Card',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
