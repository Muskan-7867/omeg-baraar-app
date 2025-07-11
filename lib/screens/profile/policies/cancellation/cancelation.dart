import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/profile/policies/privacy/widgets/bullet_list.dart';
import 'package:omegbazaar/screens/profile/policies/privacy/widgets/paragraph.dart';
import 'package:omegbazaar/screens/profile/policies/privacy/widgets/second_paragraph.dart';

class CancelationPolicy extends StatelessWidget {
  const CancelationPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Paragraph(
            'At OmegBazaar, we strive to provide a smooth and fair shopping experience. Below is our cancellation and return policy:',
          ),
          BulletList([
            'Orders can be cancelled within the same day of placing them, unless they have already been processed or shipped.',
            'Returns are accepted only for damaged, defective, or incorrect items. These must be reported within 24 hours of delivery.',
            'For any product-related issues, especially those with manufacturer warranties, please contact the brand’s support directly.',
            'If a return is approved, refunds will be processed within 3–5 business days to the original payment method.',
          ]),
          SecondParagraph([
            TextSpan(
              text:
                  'If you believe you’ve received an incorrect or unsatisfactory item, please reach out to our customer support team at ',
            ),
            TextSpan(
              text: 'omegbazaarofficial@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' with your order details and concern.'),
          ]),
        ],
      ),
    );
  }
}
