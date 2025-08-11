import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:omeg_bazaar/provider/cart_provider.dart';
// import 'package:omeg_bazaar/services/cart/cart_helper.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/utills/app_pages.dart';
import 'package:omeg_bazaar/widgets/uiHelper/ui_helper.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    handleNaviagate();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initializeAndNavigate();
    // });
  }

  Future<void> handleNaviagate() async {
    Future.delayed(Duration(seconds: 2), () async {
      // Check first launch status before running the app
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
      // final initialRoute = isFirstLaunch ? Routes.splash : Routes.home;
      if (isFirstLaunch) {
        Get.offAllNamed(Routes.intro);
        prefs.setBool("first_launch", true);
      } else {
        Get.offAllNamed(Routes.home);
      }
    });
  }

  // Future<void> _initializeAndNavigate() async {
  //   try {
  //     // Initialize cart count
  //     final cart = Provider.of<CartProvider>(context, listen: false);
  //     final items = await CartHelper.getCartItems();
  //     cart.setCount(items.length);

  //     // Navigate after 2 seconds
  //     Timer(const Duration(seconds: 2), () async {
  //       // Mark that the app has been launched before
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool('first_launch', false);

  //       // Navigate to intro screen (only first time)
  //       Get.offAllNamed(Routes.intro, predicate: (route) => false);
  //     });
  //   } catch (e) {
  //     debugPrint('Error in splash screen: $e');
  //     // Fallback navigation
  //     Get.offAllNamed(Routes.home, predicate: (route) => false);
  //   }
  // }

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
