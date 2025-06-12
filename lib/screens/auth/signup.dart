import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/divider_signup.dart';
import 'package:omeg_bazaar/widgets/common/gradient_btn.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Arrow icon (no padding)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),

              // Everything else with horizontal padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: const Text(
                        "Create your account to get started on your journey with us",
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Icon(Icons.lock, size: 80, color: Colors.black),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "UserName",
                        prefixIcon: const Icon(Icons.supervised_user_circle),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 40),
                    GradientButton(
                      text: "Sign Up",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/verify');
                      },
                    ),
                    const SizedBox(height: 30),
                    const DividerAndSignUp(isLoginPage: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
