import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color.fromARGB(0, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColour.secondaryColor,
            ),
            child: Image.asset("assets/images/bag.png"),
          ),
          SizedBox(height: 10),
          Text(
            'Stationary',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
