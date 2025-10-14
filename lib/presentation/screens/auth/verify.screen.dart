import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/crashlytics/crashlytics.helper.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  

  Future<bool> updateStatus(bool isVerify) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final check = await userProvider.updateIsVerify(uid, isVerify);
    if (check) {
      return true;
    } else {
      return false;
    }
  }

  void verify() async {
    LoadingPopup.show('Verifying...');
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        final updateResult = await updateStatus(true);
        EasyLoading.dismiss();
        if (updateResult) {
          context.go('/main');
          EasyLoading.showSuccess('Verified !', duration: Duration(seconds: 2));
        } else {
          AppTopSnackbar.showTopSnackBar(context, "Database update failed !");
        }
      } else {
        EasyLoading.dismiss();
        AppTopSnackbar.showTopSnackBar(context, "Email not verified yet !");
      }
    } catch (e) {
      EasyLoading.dismiss();
      AppTopSnackbar.showTopSnackBar(context, "Something went wrong !");
      debugPrint('Verify error: $e');
    }
  }

  reSend() async {
    LoadingPopup.show('Sending...');
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null) {
        await refreshedUser.sendEmailVerification();
        debugPrint("Verification email sent to ${refreshedUser.email}");
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Sent !', duration: Duration(seconds: 2));
      } else {
        EasyLoading.dismiss();
        AppTopSnackbar.showTopSnackBar(context, "User already verified !");
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint("Error resend: $e");
      AppTopSnackbar.showTopSnackBar(context, "Please try again !");
    }
  }

  
  @override
  void initState() {
     
    super.initState();
    CrashlyticsHelper.logScreenView("Verify Screen");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Icon(
                Icons.email_outlined,
                size: 80,
                color: theme.primaryColor,
              ),
              SizedBox(height: 28),
              Text(
                'Check your inbox',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'We\'ve sent a verification link to your email address. Please check your spam folder if you don\'t see it.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              AppButtons(
                text: "Verify",
                isPrimary: true,
                width: double.infinity,
                height: 50,
                icon: Icons.check,
                onTap: () {
                  verify();
                },
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  // resend
                  reSend();
                },
                child: Text(
                  'Resend',
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: theme.primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/login');
                    },
                    child: Text(
                      'Back login',
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.primaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: theme.primaryColor,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
