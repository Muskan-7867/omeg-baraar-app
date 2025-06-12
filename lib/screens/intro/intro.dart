import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/intro/widgets/headingSection.dart';
import 'package:omeg_bazaar/screens/intro/widgets/imageSection.dart';
import 'package:omeg_bazaar/utills/app_router.dart';
import 'package:omeg_bazaar/widgets/common/rounded_Button.dart';

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
              child: RoundedButton(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRouter.home);
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
