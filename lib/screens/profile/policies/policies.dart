import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/profile/policies/cancellation/cancelation.dart';
import 'package:omeg_bazaar/screens/profile/policies/contactus/contact_us.dart';
import 'package:omeg_bazaar/screens/profile/policies/privacy/privacy_data.dart';
import 'package:omeg_bazaar/screens/profile/policies/terms/terms_data.dart';
import 'package:omeg_bazaar/screens/profile/user_profile.dart';

class Policies extends StatefulWidget {
  const Policies({super.key});

  @override
  State<Policies> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<Policies> {
  final Map<String, bool> _expandedItems = {
    'Privacy Policy': false,
    'Terms and Conditions': false,
    'Contact Us': false,
    'Cancel & Return Policy': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Policy & information'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAccordian(title: 'Privacy policy', content: PrivacyData()),
            _buildAccordian(
              title: 'Terms and Conditions',
              content: TermsAndConditions(),
            ),
            _buildAccordian(title: 'Conatct Us', content: ContactUs()),
            _buildAccordian(
              title: 'Cancel & Return Policy',
              content: CancelationPolicy(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordian({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        borderOnForeground: false,
        elevation: 0,
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          initiallyExpanded: _expandedItems[title] ?? false,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedItems[title] = expanded;
            });
          },
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: content),
          ],
        ),
      ),
    );
  }
}
