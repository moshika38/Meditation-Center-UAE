import 'package:flutter/material.dart';
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
            children: const [
              // Title
              Text(
                "TERMS & CONDITIONS",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Meditation Center UAE",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 20),

              // Section 1
              Text(
                "1. හැඳින්වීම",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "මෙම නීති සහ කොන්දේසි ඔබ (පරිශීලකයා) සහ Meditation Center UAE අතර ඇති නීතිමය ගිවිසුමකි. "
                "මෙම සේවාව භාවිතා කිරීමෙන් ඔබ මෙම කොන්දේසි පිළිගනී.",
              ),

              SizedBox(height: 16),

              // Section 2
              Text(
                "2. සේවාව පිළිබඳ සාමාන්‍ය කරුණු",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "අපගේ ඇප් එක මනෝසමාධි, ධ්‍යානය සහ සෞඛ්‍ය වර්ධනය සඳහා නිර්මාණය කර ඇති අතර, "
                "මෙය පුද්ගලික භාවිතය සඳහා පමණක් යොදාගත යුතුය.",
              ),

              SizedBox(height: 16),

              // Section 3
              Text(
                "3. සෞඛ්‍ය සහ වෛද්‍ය ඉවහල් කිරීම",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "මෙම ඇප් තුළ ඇති අන්තර්ගතය මනෝසමාධි සහ සෞඛ්‍ය උපකාර සඳහා පමණක් වන අතර, "
                "එය වෘත්තීය වෛද්‍ය උපදෙස් ලෙස සැලකිය නොහැක. "
                "ඔබට සෞඛ්‍ය ගැටළු ඇති නම්, වෘත්තීය වෛද්‍ය උපදෙස් ලබාගන්න.",
              ),

              SizedBox(height: 16),

              // Section 4
              Text(
                "4. පරිශීලක ගිණුම් සහ පෞද්ගලිකත්වය",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "ඔබ ගිණුමක් සාදන විට සත්‍ය සහ නිරවද්‍ය තොරතුරු ලබාදිය යුතුය. "
                "ඔබගේ පෞද්ගලික තොරතුරු අපගේ Privacy Policy එකට අනුකූලව ආරක්ෂා කරනු ලබයි.",
              ),

              SizedBox(height: 16),

              // Section 5
              Text(
                "5. අන්තර්ගත හිමිකම",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "ඇප් තුළ පවතින සියලුම අන්තර්ගතය, ඇතුළු පාඨ, රූප, විඩියෝ, සහ සංකල්පනාවන්, "
                "Meditation Center UAE හි අයිතියට යටත් වේ. "
                "අනවසරයෙන් නකල් කිරීම හෝ බෙදාහැරීම තහනම්.",
              ),

              SizedBox(height: 16),

              // Section 6
              Text(
                "6. භාවිතයේ සීමා",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "ඔබ මෙම සේවාව නීතිවිරෝධී, අපහාසජනක, හෝ අනවසර ක්‍රියා සඳහා භාවිතා කිරීමට නොහැක. "
                "අපට ඔබගේ ගිණුම අත්හිටුවන හෝ අවලංගු කරන අයිතිය ඇත.",
              ),

              SizedBox(height: 16),

              // Section 7
              Text(
                "7. වගකීමේ සීමාව",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "මෙම සේවාව “as-is” ආකාරයෙන් ලබා දෙන අතර, Meditation Center UAE "
                "ඇප් භාවිතය හේතුවෙන් ඇතිවිය හැකි සෘජු, පරෝක්ෂ හෝ අහඹු හානියක් සඳහා වගකීම නොදරයි.",
              ),

              SizedBox(height: 16),

              // Section 8
              Text(
                "8. නීතිමය බලපාලනය",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "මෙම නීති සහ කොන්දේසි එක්සත් අරාබි එමිරේට්ස් (UAE) නීති යටතේ පාලනය සහ "
                "අර්ථකථනය කෙරේ. විවාද ඇතිවුවහොත්, එය UAE අධිකරණ බලතල යටතේ විසඳනු ලබයි.",
              ),

              SizedBox(height: 30),

              Center(
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
