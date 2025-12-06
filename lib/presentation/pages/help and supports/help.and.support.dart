import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
        title: Text(
          'Help & Support',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "ඔබට අපගේ Meditation Center app එක භාවිතා කරන අතරතුර ගැටළු ඇත්නම් "
                    "පහත උපදෙස් බලන්න. තවමත් ගැටළු විසඳන්න බැරි නම් "
                    "support team එකට සම්බන්ධ වෙන්න.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.whiteColor,
                        ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Frequently Asked Questions (FAQ)",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                        ),
                  ),
                  const SizedBox(height: 15),

                  _buildFaqItem(
                    context,
                    "Notifications off කරන්න පුලුවන්ද?",
                    "Settings > Preference > Notifications යන්න. එතැනින් push notifications enable/disable කරන්න.",
                  ),
                  _buildFaqItem(
                    context,
                    "Profile photo එක change කරන්න පුලුවන්ද?",
                    "Account settings > Profile icon එකෙ camera icon එක click කරලා අවශ්‍ය image එක upload කරන්න.",
                  ),
                  _buildFaqItem(
                    context,
                    "App එක update කරන්න ඕනේ නම්?",
                    "Update banner එක show වෙනවා නම් Play Store / App Store එකෙන් update කරන්න.",
                  ),
                  _buildFaqItem(
                    context,
                    "App crashes වුණොත් කරන්නෙ?",
                    "App එක close කරලා, device restart කරන්න. තවම issue එක තියෙනවා නම් support team එකට report කරන්න.",
                  ),
                  const SizedBox(height: 20),
                  // button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whiteColor,
                      foregroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                    ),
                    onPressed: () {
                      context.push('/socialMedia');
                    },
                    icon: const Icon(Icons.support_agent, size: 24),
                    label: const Text(
                      "Contact Support Team",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // bottom logo

            Center(
              child: Image.asset(
                "assets/logo/header-text.png",
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.whiteColor.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline, color: AppColors.whiteColor),
        title: Text(
          question,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
        ),
        iconColor: AppColors.whiteColor,
        collapsedIconColor: AppColors.whiteColor,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.whiteColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
