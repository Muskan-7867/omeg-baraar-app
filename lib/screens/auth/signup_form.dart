import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpForm({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Center(
            child: Text(
              "Create Account",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              "Create your account to get started on your journey with us",
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 40),
          const Center(child: Icon(Icons.lock, size: 80, color: Colors.black)),
          const SizedBox(height: 60),
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: "Username",
              prefixIcon: Icon(Icons.supervised_user_circle),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
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
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock),
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
        ],
      ),
    );
  }
}
