import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DividerAndSignUp extends StatelessWidget {
  final bool isLoginPage;

  const DividerAndSignUp({super.key, required this.isLoginPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLoginPage
                  ? "Don’t have an account? "
                  : "Already have an account? ",
            ),
            GestureDetector(
              onTap: () =>  Get.toNamed(isLoginPage ? '/signup' : '/login'),
              child: Text(
                isLoginPage ? "Sign Up" : "Sign In",
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
