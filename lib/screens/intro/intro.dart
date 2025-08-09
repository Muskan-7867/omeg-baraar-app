import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/intro/widgets/heading_section.dart';
import 'package:omeg_bazaar/screens/intro/widgets/image_section.dart';
import 'package:omeg_bazaar/utills/app_pages.dart';
import 'package:omeg_bazaar/widgets/common/round_btn.dart';


class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 7, child: ImageSection()),
            Expanded(flex: 3, child: Center(child: HeadingSection())),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: RoundButton(
                onTap: () {
                  Get.offAllNamed(Routes.home);
                },
                title: 'Get Started',
                height: 50,
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
