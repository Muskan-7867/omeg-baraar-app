import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class MyBanner extends StatefulWidget {
  const MyBanner({super.key});

  @override
  State<MyBanner> createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColour.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Shopping!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'With Omeg Bazaar!!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Image.asset("assets/images/bag.png"),
          ],
        ),
      ),
    );
  }
}
