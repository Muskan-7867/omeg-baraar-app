import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/profile/widgets/log_out_bottom_sheet.dart';

List<Map<String, dynamic>> getProfileOptions(BuildContext context) {
  return [
    {
      'icon': Icons.shopping_basket,
      'title': "My Orders",
      'onTap': () {
        Get.offNamed( "/orders");
      },
    },

    {
      'icon': Icons.payment,
      'title': "Payment Methods",
      'onTap': () => Get.offNamed( "/paymentmethod"),
    },
    {'icon': Icons.help_center, 'title': "Help Center", 'onTap': () {}},
    {
      'icon': Icons.privacy_tip,
      'title': "Privacy Policy",
      'onTap': () => Get.offNamed( "/privacy"),
    },
    {
      'icon': Icons.settings,
      'title': "Settings",
      'onTap': () => Get.offNamed( "/settings"),
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
