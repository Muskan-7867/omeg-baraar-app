import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/auth/signin_form.dart';
import 'package:omeg_bazaar/services/user/user_signin.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/divider_signup.dart';
import 'package:omeg_bazaar/widgets/common/gradient_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await UserAuth().loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (result['success'] == true) {
        if (result['token'] != null) {
          await _saveToken(result['token']);
        }
        _emailController.clear();
        _passwordController.clear();
        _formKey.currentState?.reset();

        Get.snackbar(
          "OMEG BAZAAR",
          result['message'] ?? 'Login successful',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );

        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          Get.offAllNamed('/home');
        }
      } else {
        Get.snackbar(
          "OMEG BAZAAR",
          result['message'] ?? 'Login failed',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
      Get.snackbar("OMEG BAZAAR", "An error occurred: ${e.toString()}");
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
                    Get.offAllNamed('/home');
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SignInForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed('/forgetpassword');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: AppColour.primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        text: _isLoading ? "Signing In..." : "Sign In",
                        onPressed: _isLoading ? null : _loginUser,
                      ),
                      const SizedBox(height: 30),
                      const DividerAndSignUp(isLoginPage: true),
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
