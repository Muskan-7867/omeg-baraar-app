import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class ProfileDropdown extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileDropdown({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(icon, color: AppColour.primaryColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: AppColour.primaryColor),
      onTap: onTap,
    );
  }
}
