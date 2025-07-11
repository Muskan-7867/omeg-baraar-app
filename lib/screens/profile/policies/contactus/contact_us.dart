import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/profile/policies/privacy/widgets/paragraph.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Paragraph("You may contact us using the information below:"),
          SizedBox(height: 12),
          ContactDetails(),
        ],
      ),
    );
  }
}

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("23-A, near Lal Chand Shoe Maker", style: TextStyle(fontSize: 14)),
        Text(
          "Prakash Nagar, Shankar Garden Colony",
          style: TextStyle(fontSize: 14),
        ),
        Text("Model Town, Jalandhar", style: TextStyle(fontSize: 14)),
        Text("Punjab 144003", style: TextStyle(fontSize: 14)),
        Text(
          "E-Mail ID: omegbazaarofficial@gmail.com",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
