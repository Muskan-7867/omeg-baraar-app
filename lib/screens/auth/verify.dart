import 'package:flutter/material.dart';
import 'package:omeg_bazaar/widgets/common/gradient_btn.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final TextEditingController _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 8),
                child: Text(
                  "Verify Code",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "Please enter the code we just sent to email",
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'Enter code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const Text(
                "Didn't Receive OTP?",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              Text(
                "Resend OTP",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.red[800],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientButton(text: 'Verify', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
