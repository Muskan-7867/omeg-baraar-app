import 'package:flutter/material.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/screens/cart/cartpage.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:provider/provider.dart';

class OmAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const OmAppBar({super.key, required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return AppBar(
          title: Text(title, style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColour.primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      // Refresh cart count before navigating
                      cart.loadCartCount();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  if (cart.count > 0)
                    Positioned(
                      right: 4,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.count}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
