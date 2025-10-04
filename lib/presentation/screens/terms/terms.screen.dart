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
                "Meditation Center UAE",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              // Section 1
              const Text(
                "1. හැඳින්වීම",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "මෙම නීති සහ කොන්දේසි ඔබ (පරිශීලකයා) සහ Meditation Center UAE අතර ඇති නීතිමය ගිවිසුමකි. "
                "මෙම සේවාව භාවිතා කිරීමෙන් ඔබ මෙම කොන්දේසි පිළිගනී.",
              ),

              const SizedBox(height: 16),

              // Section 2
              const Text(
                "2. සේවාව පිළිබඳ සාමාන්‍ය කරුණු",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "අපගේ ඇප් එක දායකයින්ගේ පහසුව සඳහා නිර්මාණය කර ඇති අතර, "
                "මෙය පුද්ගලික භාවිතය සඳහා පමණක් යොදාගත යුතුය.",
              ),

              const SizedBox(height: 16),

              // Section 3
              const Text(
                "3. සෞඛ්‍ය සහ වෛද්‍ය ඉවහල් කිරීම",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "මෙම ඇප් තුළ ඇති අන්තර්ගතය මනෝසමාධි සහ සෞඛ්‍ය උපකාර සඳහා පමණක් වන අතර, "
                "එය වෘත්තීය වෛද්‍ය උපදෙස් ලෙස සැලකිය නොහැක. "
                "ඔබට සෞඛ්‍ය ගැටළු ඇති නම්, වෘත්තීය වෛද්‍ය උපදෙස් ලබාගන්න.",
              ),

              const SizedBox(height: 16),

              // Section 4
              const Text(
                "4. පරිශීලක ගිණුම් සහ පෞද්ගලිකත්වය",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          "ඔබ ගිණුමක් සාදන විට සත්‍ය සහ නිරවද්‍ය තොරතුරු ලබාදිය යුතුය. ඔබගේ පෞද්ගලික තොරතුරු අපගේ ",
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
                    const TextSpan(
                      text: " එකට අනුකූලව ආරක්ෂා කරනු ලබයි.",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section 5
              const Text(
                "5. අන්තර්ගත හිමිකම",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "ඇප් තුළ පවතින සියලුම අන්තර්ගතය, ඇතුළු පාඨ, රූප, විඩියෝ, සහ සංකල්පනාවන්, "
                "Meditation Center UAE හි අයිතියට යටත් වේ. "
                "අනවසරයෙන් පිටපත් කිරීම හෝ බෙදාහැරීම තහනම්.",
              ),

              const SizedBox(height: 16),

              // Section 6
              const Text(
                "6. භාවිතයේ සීමා",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "ඔබ මෙම සේවාව නීතිවිරෝධී, අපහාසජනක, හෝ අනවසර ක්‍රියා සඳහා භාවිතා කිරීමට නොහැක. "
                "අපට ඔබගේ ගිණුම අත්හිටුවන හෝ අවලංගු කරන අයිතිය ඇත.",
              ),

              const SizedBox(height: 16),

              // Section 7
              const Text(
                "7. වගකීමේ සීමාව",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "මෙම සේවාව “as-is” ආකාරයෙන් ලබා දෙන අතර, Meditation Center UAE "
                "ඇප් භාවිතය හේතුවෙන් ඇතිවිය හැකි සෘජු හෝ අහඹු හානියක් සඳහා වගකීම නොදරයි.",
              ),

              const SizedBox(height: 16),

              // Section 8
              const Text(
                "8. නීතිමය බලපාලනය",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "මෙම නීති සහ කොන්දේසි එක්සත් අරාබි එමිරේට්ස් (UAE) නීති යටතේ පාලනය සහ "
                "අර්ථකථනය කෙරේ. විවාද ඇතිවුවහොත්, එය UAE අධිකරණ බලතල යටතේ විසඳනු ලබයි.",
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "© 2025 Meditation Center UAE",
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
