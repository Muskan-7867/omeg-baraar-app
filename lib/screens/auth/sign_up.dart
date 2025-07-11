import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/auth/signup_form.dart';
import 'package:omegbazaar/services/user/user_signup.dart';
import 'package:omegbazaar/widgets/common/divider_signup.dart';
import 'package:omegbazaar/widgets/common/gradient_btn.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await UserRegister().registerUser(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        // Clear fields
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _formKey.currentState?.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Registration successful'),
            duration: const Duration(seconds: 1),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1500));
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SignUpForm(
                        usernameController: _usernameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        text: _isLoading ? "Signing Up..." : "Sign Up",
                        onPressed: _isLoading ? null : () => _registerUser(),
                      ),
                      const SizedBox(height: 30),
                      const DividerAndSignUp(isLoginPage: false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
