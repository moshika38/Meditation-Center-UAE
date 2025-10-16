import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "TERMS & CONDITIONS",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "CMC UAE — Ceylon Meditation Center",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),
              // Section 1
              const Text(
                "1. Introduction",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "These Terms and Conditions form a legal agreement between you (the user) and CMC UAE. "
                "By using this app, you acknowledge that you have read and accepted these terms.",
              ),

              const SizedBox(height: 16),
              // Section 2
              const Text(
                "2. About Our Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "The CMC UAE app is designed to provide users with information about programs, meditation events, and special announcements conducted by the Ceylon Meditation Center. "
                "Push notifications are used to inform users about special updates and activities.",
              ),

              const SizedBox(height: 16),
              // Section 3 (Removed Health/Medical Section)

              // Section 4
              const Text(
                "3. User Accounts and Privacy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          "When creating an account, you must provide accurate and truthful information. "
                          "Your personal data will be protected in accordance with the app’s rules and our ",
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push('/privacy');
                        },
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Section 5
              const Text(
                "4. Content Ownership",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "All content within the CMC UAE app — including text, images, videos, and concepts — "
                "is the property of Ceylon Meditation Center UAE. Unauthorized copying or distribution is strictly prohibited.",
              ),

              const SizedBox(height: 16),

              // Section 6
              const Text(
                "5. Usage Restrictions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "You may not use this service for illegal, unauthorized, or unlawful purposes. "
                "CMC UAE reserves the right to suspend or terminate any account that violates these terms.",
              ),

              const SizedBox(height: 16),

              // Section 7
              const Text(
                "6. Push Notifications and Announcements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "The app sends push notifications to inform users about temple programs, meditation events, and announcements. "
                "You may choose to disable push notifications at any time through your device settings.",
              ),

              const SizedBox(height: 16),
              // Section 8
              const Text(
                "7. Limitation of Liability",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "This service is provided 'as-is'. CMC UAE shall not be held responsible for any damages or losses "
                "arising from the use of this app.",
              ),

              const SizedBox(height: 16),
              // Section 9
              const Text(
                "8. Governing Law",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "These Terms and Conditions are governed by the laws of the United Arab Emirates (UAE).",
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "© 2025 Ceylon Meditation Center UAE",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
