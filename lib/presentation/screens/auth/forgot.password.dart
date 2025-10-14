import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/components/app.input.dart';
import 'package:meditation_center/presentation/components/app.logo.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/services/auth.services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController forgotPasswordController = TextEditingController();
  bool isErr = false;

  void reset() {
    setState(() {
      isErr = forgotPasswordController.text.isEmpty;
    });

    if (!isErr) {
      LoadingPopup.show('Sending...');

      if (AuthServices.isValidEmail(forgotPasswordController.text)) {
        // send reset password link
        AuthServices.resetPassword(forgotPasswordController.text);
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Successfully !',
            duration: Duration(seconds: 2));
      } else {
        AppTopSnackbar.showTopSnackBar(context, "Please enter a valid email");
        EasyLoading.dismiss();
      }
    }
  }

  @override
  void initState() {
     
    super.initState();
     FirebaseCrashlytics.instance.log("User opened ForgotPassword Screen");
    FirebaseCrashlytics.instance.setCustomKey('screen', 'ForgotPassword Screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Center(
                child: AppLogo(
                  width: 100,
                  height: 100,
                ),
              ),
              Spacer(),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Forgot Password",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Text(
                      "Enter your email address to receive a link to reset your password.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    AppInput(
                      hasError: isErr,
                      controller: forgotPasswordController,
                      hintText: isErr
                          ? ": Please enter email address"
                          : "Email address",
                      prefixIcon: Icons.email_outlined,
                      suffixIcon: Icons.cancel_sharp,
                      onTapIcon: () {
                        setState(() {
                          forgotPasswordController.clear();
                        });
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    AppButtons(
                      icon: Icons.send,
                      isPrimary: true,
                      text: "Send",
                      width: double.infinity,
                      height: 50,
                      onTap: () {
                        reset();
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              Spacer(),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primaryColor,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to login",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.primaryColor,
                          ),
                    ),
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
