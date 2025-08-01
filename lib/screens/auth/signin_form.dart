import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class SignInForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        const Text(
          "Sign In",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8),
        const Text(
          "Welcome back, please login to your account",
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 40),
        const Icon(Icons.lock, size: 80, color: Colors.black),
        const SizedBox(height: 40),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            prefixIcon: const Icon(Icons.email),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColour.primaryColor,
              ), // not focused
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(Icons.lock),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColour.primaryColor,
              ), // not focused
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (!RegExp(
              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#^+=])[A-Za-z\d@$!%*?&#^+=]{8,}$',
            ).hasMatch(value)) {
              return 'Password must be at least 8 characters with uppercase, lowercase, number, and special character';
            }
            return null;
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
