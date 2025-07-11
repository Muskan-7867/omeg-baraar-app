import 'package:flutter/material.dart';
import 'package:omegbazaar/utills/app_colour.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const TitleWidget({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onSeeAll != null
            ? TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See All',
                style: TextStyle(color: AppColour.primaryColor),
              ),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
