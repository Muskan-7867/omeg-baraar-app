import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to $email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your email address to receive a password reset link.",
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(
                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Send Reset Link"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
