import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/policies/privacy/widgets/bullet_list.dart';
import 'package:omeg_bazaar/screens/profile/policies/privacy/widgets/paragraph.dart';
import 'package:omeg_bazaar/screens/profile/policies/privacy/widgets/second_paragraph.dart';
import 'package:omeg_bazaar/screens/profile/policies/privacy/widgets/section_title.dart';

class PrivacyData extends StatelessWidget {
  const PrivacyData({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Paragraph(
            "This privacy policy outlines how OmegBazaar collects, uses, and protects your personal information when you visit our website or make a purchase.",
          ),
          Paragraph(
            "We are committed to protecting your data. Any information we collect will only be used in accordance with this policy.",
          ),
          SectionTitle("Information We Collect"),
          BulletList([
            "Name and contact details",
            "Email address",
            "Shipping and billing address",
            "Preferences and feedback",
          ]),
          SectionTitle("Why We Collect It"),
          BulletList([
            "To process your orders",
            "To improve our products and services",
            "To send order updates, offers, or feedback forms",
          ]),
          SectionTitle("Security"),
          Paragraph(
            "We use appropriate measures to prevent unauthorized access or disclosure of your data.",
          ),
          SectionTitle("Cookies"),
          Paragraph(
            "We use cookies to enhance user experience. You can control cookie usage through your browser settings.",
          ),
          SectionTitle("Your Rights"),
          SecondParagraph([
            TextSpan(
              text:
                  "You may update or request deletion of your personal data by contacting us at ",
            ),
            TextSpan(
              text: "omegbazaarofficial@gmail.com",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "."),
          ]),
          Paragraph(
            "We do not share your data with third parties without your consent, unless required by law.",
          ),
        ],
      ),
    );
  }
}
