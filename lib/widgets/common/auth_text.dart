import 'package:flutter/material.dart';

class AuthRedirectText extends StatelessWidget {
  final bool isLoginPage; // true for login, false for signup
  final VoidCallback onTap;

  const AuthRedirectText({
    super.key,
    required this.isLoginPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLoginPage
              ? "Don’t have an account? "
              : "Already have an account? ",
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            isLoginPage ? "Sign Up" : "Sign In",
            style: const TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
