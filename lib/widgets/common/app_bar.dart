import 'package:flutter/material.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/screens/cart/cartpage.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OmAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const OmAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<OmAppBar> createState() => _OmAppBarState();
}

class _OmAppBarState extends State<OmAppBar> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColour.primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
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
                  IconButton(
                    onPressed: () {
                      if (_isLoggedIn) {
                        Navigator.pushNamed(context, '/profile');
                      } else {
                        Navigator.pushNamed(context, '/login').then((_) {
                          _checkLoginStatus(); // recheck login after returning
                        });
                      }
                    },
                    icon:
                        _isLoggedIn
                            ? const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 32,
                            )
                            : Image.asset(
                              "assets/icons/login.png",
                              color: Colors.white,
                              width: 30,
                              height: 30,
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
