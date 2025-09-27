import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/introduction.text.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  int durationVal = 100;
  bool isSwitch = true;

  Future<void> _getUserData() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final provider = Provider.of<UserProvider>(context, listen: false);
    final user = await provider.getUserById(id);
    setState(() {
      isSwitch = user.allowNotification;
    });
  }

  void updateNotificationSettings(bool nValue) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (nValue) {
      messaging.subscribeToTopic('all_users');
      print("🛑  Subscribed to all_users topic");
    } else {
      messaging.unsubscribeFromTopic('all_users');
      print("🛑 Unsubscribed from all_users topic");
    }
    await provider.updateNotificationSettings(nValue);
  }


  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // theme
    final theme = Theme.of(context);
    // height
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
        title: Text(
          'Animation Settings',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "Notifications Settings",
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: AppColors.whiteColor),
              ),
            ),
            SizedBox(height: height * 0.01),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.secondaryColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      !isSwitch
                          ? "Enable Notifications"
                          : "Disable Notifications",
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: AppColors.whiteColor),
                    ),
                    // switch button
                    Switch(
                      value: isSwitch,
                      activeColor: AppColors.secondaryColor,
                      activeTrackColor: AppColors.primaryColor,
                      inactiveThumbColor: AppColors.gray,
                      inactiveTrackColor: AppColors.whiteColor,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                        updateNotificationSettings(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            IntroductionText.text(
              theme,
              "Use the toggle above to temporarily pause all notifications",
              false,
            ),
            IntroductionText.text(
              theme,
              "Reopen the app for the newly applied changes to take effect immediately.",
              false,
            ),
            IntroductionText.text(
              theme,
              "You can reactivate notifications at any time you wish.",
              false,
            ),
            Spacer(),
            Center(
              child: Image.asset(
                "assets/logo/header-text.png",
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
