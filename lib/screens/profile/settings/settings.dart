import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/profile.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_dropdowns.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ProfileDropdown(
              icon: Icons.settings_accessibility,
              title: 'Notification Settings',
              onTap: () {},
            ),
            ProfileDropdown(
              icon: Icons.key,
              title: 'Password Manager',
              onTap: () {},
            ),
            ProfileDropdown(
              icon: Icons.delete,
              title: 'Delete Account',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
