import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utills/app_colour.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color bgColor;
  final String title;
  final double borderRadius;
  final String? iconName;

  const RoundedButton({
    super.key,
    required this.onTap,
    this.width = double.infinity,
    this.height = 50,
    this.bgColor = AppColour.primaryColor,
    this.title = 'Button',
    this.borderRadius = 60,
    this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            iconName != null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/$iconName",
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
                : Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
      ),
    );
  }
}
