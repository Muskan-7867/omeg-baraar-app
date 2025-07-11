import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/intro/widgets/heading_section.dart';
import 'package:omegbazaar/screens/intro/widgets/image_section.dart';
import 'package:omegbazaar/utills/app_router.dart';
import 'package:omegbazaar/widgets/common/rounded_button.dart';

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
