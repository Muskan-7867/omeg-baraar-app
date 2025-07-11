import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/profile/policies/privacy/widgets/bullet_list.dart';
import 'package:omegbazaar/screens/profile/policies/privacy/widgets/paragraph.dart';
import 'package:omegbazaar/screens/profile/policies/privacy/widgets/section_title.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Paragraph(
            'For the purpose of these Terms and Conditions, the terms “we”, “us”, “our” shall refer to OmegBazaar, whose registered/operational office is Model Town, Jalandhar, Punjab 144002. The terms “you”, “your”, “user”, “visitor” shall refer to any natural or legal person who is visiting our website and/or agreed to purchase from us.',
          ),
          SectionTitle(
            'Your use of the website and purchase from us are governed by the following Terms and Conditions:',
          ),
          BulletList([
            'The content of the pages of this website is subject to change without notice.',
            'Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness or suitability of the information and materials found or offered on this website for any particular purpose.',
            'Your use of any information or materials on our website is entirely at your own risk, for which we shall not be liable.',
            'Our website contains material which is owned by or licensed to us. Reproduction is prohibited.',
            'All trademarks not owned by OmegBazaar are acknowledged on the website.',
            'Unauthorized use of information provided by us may result in legal action.',
            'We may link to external websites for convenience. We are not responsible for their content.',
            'You may not link to us without prior written consent from OmegBazaar.',
            'All disputes are subject to the laws of India.',
            'We are not liable for failed transactions due to card limits or bank issues.',
          ]),
        ],
      ),
    );
  }
}
