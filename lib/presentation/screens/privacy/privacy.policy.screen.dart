import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for CMC UAE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Effective Date: October 16, 2025\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Ceylon Meditation Center (CMC UAE) operates this mobile application to share meditation-related information, temple events, spiritual programs, and notifications. This Privacy Policy explains how we collect, use, and protect your personal information.',
            ),
            SizedBox(height: 16),
            Text(
              '1. Information We Collect',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We may collect the following information when you use our app:\n• Personal information (name, email, phone number) if you choose to register.\n• Device information and usage data (for app performance).\n• Firebase-generated identifiers for authentication, analytics, and notifications.',
            ),
            SizedBox(height: 16),
            Text(
              '2. How We Use Your Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We use your information to:\n• Provide and improve our app services.\n• Send notifications about upcoming events or announcements.\n• Enhance app security and prevent misuse.\n• Analyze app usage to improve user experience.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Data Sharing and Disclosure',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We do not sell or trade your personal information. Data may be shared only with trusted third-party services such as Firebase (for hosting, authentication, and notifications) under strict privacy agreements.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Data Retention and Security',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Your information is retained only as long as necessary to provide services. We implement appropriate security measures to protect your data against unauthorized access or misuse.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Your Rights',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'You may:\n• Request access or correction of your personal data.\n• Request deletion of your account.\n• Opt out of receiving push notifications at any time through your device settings.',
            ),
            SizedBox(height: 16),
            Text(
              '6. Children’s Privacy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Our app is not designed for children under the age of 13. We do not knowingly collect personal data from children.',
            ),
            SizedBox(height: 16),
            Text(
              '7. Changes to This Policy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We may update this Privacy Policy from time to time. Updates will be reflected within the app with a new effective date.',
            ),
            SizedBox(height: 16),
            Text(
              '8. Contact Us',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at:\nEmail: info.app.cmc@gmail.com\n',
            ),
            SizedBox(height: 24),
            Text(
              'Thank you for using CMC UAE!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
