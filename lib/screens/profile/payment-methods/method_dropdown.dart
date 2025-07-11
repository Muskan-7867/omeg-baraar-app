import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class PaymentMethodDropdown extends StatelessWidget {
  final IconData icon;
  final String title;

  const PaymentMethodDropdown({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(icon, color: AppColour.primaryColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }
}
