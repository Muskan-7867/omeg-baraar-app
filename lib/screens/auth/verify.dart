import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omeg_bazaar/widgets/common/gradient_btn.dart';

class VerifyUser extends StatefulWidget {
  final String email;
  final String userId;
  final Function(String) onVerificationComplete;
  final Function() onResendOtp;

  const VerifyUser({
    super.key,
    required this.email,
    required this.userId,
    required this.onVerificationComplete,
    required this.onResendOtp,
  });

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  bool _canResend = false;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 30;
    setState(() {});

    Future.delayed(const Duration(seconds: 1), () {
      if (_resendCountdown > 0) {
        _resendCountdown--;
        _startResendTimer();
      } else {
        _canResend = true;
        setState(() {});
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    widget.onResendOtp();
    _startResendTimer();
  }

  void _verifyOtp() async {
    if (_codeController.text.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter a valid 4-digit OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Add a small delay to ensure smooth processing
      await Future.delayed(const Duration(milliseconds: 100));
      await widget.onVerificationComplete(_codeController.text);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Verification failed. Please try again.',
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Verify Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Please enter the code we just sent to your email address",
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Enter code',
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: GradientButton(text: 'Verify', onPressed: _verifyOtp),
                ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't Receive OTP?",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: _canResend ? _resendOtp : null,
                  child: Text(
                    _canResend ? "Resend OTP" : "Resend in $_resendCountdown",
                    style: TextStyle(
                      fontSize: 14,
                      color: _canResend ? Colors.red[800] : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
