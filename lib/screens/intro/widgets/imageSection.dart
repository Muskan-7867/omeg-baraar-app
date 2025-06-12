import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key});

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColour.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 500,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColour.whiteColor, AppColour.primaryColor],
                  ),
                ),
                child: Image.asset("assets/images/toy.png"),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColour.primaryColor,
                            AppColour.whiteColor,
                          ],
                        ),
                      ),
                      child: Image.asset("assets/images/bag.png"),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
