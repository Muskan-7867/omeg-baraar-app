import 'dart:async';

import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/utills/app_router.dart';
import 'package:omeg_bazaar/widgets/uiHelper/ui_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
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
            Text(
              'Omeg',
              style: TextStyle(fontSize: 50, fontFamily: 'Poppins-Medium'),
            ),
            Text('Bazaar', style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
