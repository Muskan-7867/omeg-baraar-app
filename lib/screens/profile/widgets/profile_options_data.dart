import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/widgets/log_out_bottom_sheet.dart';

List<Map<String, dynamic>> getProfileOptions(BuildContext context) {
  return [
    {
      'icon': Icons.shopping_basket,
      'title': "My Orders",
      'onTap': () {
        Navigator.pushReplacementNamed(context, "/orders");
      },
    },

    {
      'icon': Icons.payment,
      'title': "Payment Methods",
      'onTap': () => Navigator.pushReplacementNamed(context, "/paymentmethod"),
    },
    {'icon': Icons.help_center, 'title': "Help Center", 'onTap': () {}},
    {'icon': Icons.privacy_tip, 'title': "Privacy Policy", 'onTap': () {}},
    {
      'icon': Icons.settings,
      'title': "Settings",
      'onTap': () => Navigator.pushReplacementNamed(context, "/settings"),
    },
    {
      'icon': Icons.logout,
      'title': "Log Out",
      'onTap':
          () => showModalBottomSheet(
            builder: (context) => const LogOutSheetCart(),
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
          ),
    },
  ];
}
