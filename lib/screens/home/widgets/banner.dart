import 'package:flutter/material.dart';
import 'package:omegbazaar/utills/app_colour.dart';

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
                  'Special Offers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'Coming soon',
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
