import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/data/services/auth.services.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      final result = await AuthServices.isEmailVerified();
      final updateResult = await updateStatus(result);

      if (updateResult) {
        context.go('/main');
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Verified !', duration: Duration(seconds: 2));
      } else {
        EasyLoading.dismiss();
        AppTopSnackbar.showTopSnackBar(context, "Email not verified !");
      }
    }

    reSend() async {
  LoadingPopup.show('Sending...');
  try {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();  
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null ) {
      await refreshedUser.sendEmailVerification();
      print("Verification email sent to ${refreshedUser.email}");
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Sent !', duration: Duration(seconds: 2));
    } else {
      EasyLoading.dismiss();
      AppTopSnackbar.showTopSnackBar(context, "User already verified !");
    }
  } catch (e) {
    EasyLoading.dismiss();
    print("Error resend: $e");
    AppTopSnackbar.showTopSnackBar(context, "Please try again !");
  }
}


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
