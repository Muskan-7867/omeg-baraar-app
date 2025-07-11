import 'package:flutter/material.dart';
import 'package:omegbazaar/utills/app_colour.dart';

class HeadingSection extends StatefulWidget {
  const HeadingSection({super.key});

  @override
  State<HeadingSection> createState() => _HeadingSectionState();
}

class _HeadingSectionState extends State<HeadingSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColour.whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' The ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '  Ultimate Shopping ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColour.primaryColor,
                ),
              ),
              Text(
                '  Experience',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          Text(
            'Shop Smarter, Shop Better',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Padding(
            // padding: const EdgeInsets.all(18.0),
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Text(
              "Discover a seamless shopping experience with unbeatable deals, top-quality products, and convenience at your fingertips. Shop smarter today!",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
