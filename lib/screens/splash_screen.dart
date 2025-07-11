import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omeg_bazaar/provider/cart_provider.dart';
import 'package:omeg_bazaar/services/cart/cart_helper.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/utills/app_router.dart';
import 'package:omeg_bazaar/widgets/uiHelper/ui_helper.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Initialize cart count
    final cart = Provider.of<CartProvider>(context, listen: false);
    final items = await CartHelper.getCartItems();
    cart.setCount(items.length);

    // Add any other initialization tasks here
    
    // Navigate after 2 seconds (maintaining your current UX)
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRouter.intro);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColour.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.customImage(image: 'bag.png'),
            const Text(
              'OMEG',
              style: TextStyle(fontSize: 50, fontFamily: 'Poppins-Medium'),
            ),
            const Text('Bazaar', style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}