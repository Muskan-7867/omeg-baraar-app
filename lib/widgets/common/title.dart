import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final bool isSmallScreen;

  const TitleWidget({super.key, required this.title, this.onSeeAll,  required this.isSmallScreen });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onSeeAll != null
            ? TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  AppColour.primaryColor,
                ),

                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              onPressed: onSeeAll,
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.white),
              ),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
