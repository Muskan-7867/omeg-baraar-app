import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/home/home.dart';
import 'package:omeg_bazaar/screens/profile/widgets/log_out_bottom_sheet.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_dropdowns.dart';
import 'package:omeg_bazaar/screens/profile/widgets/profile_options.dart';
import 'package:omeg_bazaar/screens/profile/widgets/user_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'icon': Icons.shopping_basket,
        'title': "My Orders",
        'onTap': () {
          Navigator.pushReplacementNamed(context, "/orders");
        },
      },
      {'icon': Icons.payment, 'title': "Payment Methods", 'onTap': () {}},
      {'icon': Icons.help_center, 'title': "Help Center", 'onTap': () {}},
      {'icon': Icons.privacy_tip, 'title': "Privacy Policy", 'onTap': () {}},
      {'icon': Icons.settings, 'title': "Settings", 'onTap': () {}},
      {
        'icon': Icons.insert_invitation_rounded,
        'title': "Invite Friends",
        'onTap': () {},
      },
      {
        'icon': Icons.logout,
        'title': "Log Out",
        'onTap': () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            builder: (context) => const LogOutSheetCart(),
          );
        },
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserInfo(),
            const SizedBox(height: 20),
            const ProfileOptions(),
            const SizedBox(height: 20),
            ...options.map((item) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: ProfileDropdown(
                      icon: item['icon'],
                      title: item['title'],
                      onTap: item['onTap'],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
