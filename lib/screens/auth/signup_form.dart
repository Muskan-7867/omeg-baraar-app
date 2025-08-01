import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/screens/auth/verify.dart';
import 'package:omeg_bazaar/services/user/verification_api.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:omeg_bazaar/widgets/common/gradient_btn.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function()? onVerificationSuccess;

  const SignUpForm({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    this.onVerificationSuccess,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _userId;

  @override
  void dispose() {
    widget.usernameController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtpAndVerify() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await VerificationService.registerUser(
        username: widget.usernameController.text.trim(),
        email: widget.emailController.text.trim(),
        password: widget.passwordController.text,
      );

      if (response['userId'] == null) {
        throw Exception('Registration failed - no user ID returned');
      }

      setState(() {
        _userId = response['userId'];
      });

      Get.to(
        () => VerifyUser(
          email: widget.emailController.text.trim(),
          userId: _userId!,
          onVerificationComplete: _verifyOtpWithBackend,
          onResendOtp: _resendOtp,
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyOtpWithBackend(String otp) async {
    if (otp.length != 4 || _userId == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await VerificationService.verifyOtp(
        userId: _userId!,
        otp: otp,
      );

      if (response['success'] == true) {
        widget.onVerificationSuccess?.call();
        Get.offAllNamed('/login');
        Get.snackbar(
          'Success',
          'Email verified successfully! Please login',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(response['message'] ?? 'Verification failed');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back(); // Return to signup form if verification fails
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_userId == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await VerificationService.resendOtp(userId: _userId!);

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to resend OTP');
      }

      Get.snackbar(
        'Success',
        'New OTP sent to your email.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
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
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Icon(Icons.lock, size: 80, color: Colors.black),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: widget.usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.supervised_user_circle),
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
                  return 'Please enter a username';
                }
                if (value.length < 3) {
                  return 'Username must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
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
              controller: widget.passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
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
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : GradientButton(
                  text: 'Sign Up & Verify Email',
                  onPressed: _sendOtpAndVerify,
                ),
          ],
        ),
      ),
    );
  }
}
