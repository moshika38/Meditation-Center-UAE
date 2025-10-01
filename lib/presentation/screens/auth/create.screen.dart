import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/components/app.input.dart';
import 'package:meditation_center/presentation/components/app.logo.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/services/auth.services.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool obscureText1 = true;
  bool obscureText2 = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  bool isAgree = true;

  bool isNameError = false;
  bool isEmailError = false;
  bool isPassError = false;
  bool isComPassError = false;

  void create() async {
    setState(() {
      isNameError = nameController.text.isEmpty;
      isEmailError = emailController.text.isEmpty;
      isPassError = passwordController.text.isEmpty;
      isComPassError = conformPasswordController.text.isEmpty;
    });

    if (!isNameError && !isEmailError && !isPassError && !isComPassError) {
      if (AuthServices.isValidEmail(emailController.text)) {
        if (passwordController.text == conformPasswordController.text) {
          if (!isAgree) {
            AppTopSnackbar.showTopSnackBar(
                context, "Please accept the terms and conditions");
            return;
          }
          // show loading
              LoadingPopup.show('Creating...');

          final result = await AuthServices.createAccountWithEmailAndPassword(
            emailController.text,
            passwordController.text,
            nameController.text,
          );
            if (!mounted) return;

          if (result == 'Successfully') {
            await AuthServices.sendEmailVerification(emailController.text);
            EasyLoading.dismiss();
            EasyLoading.showSuccess('Successfully !',
                duration: Duration(seconds: 2));
            context.push('/verify');
            // navigate to verify screen
          } else if (result == 'errCode1') {
            AppTopSnackbar.showTopSnackBar(context, "Password is too weak");
            EasyLoading.dismiss();
          } else if (result == 'errCode2') {
            AppTopSnackbar.showTopSnackBar(context, "Email already in use");
            EasyLoading.dismiss();
          } else {
            AppTopSnackbar.showTopSnackBar(context, "Unknown error occurred.");
            EasyLoading.dismiss();
          }
        } else {
          AppTopSnackbar.showTopSnackBar(context, "Passwords do not match");
        }
      } else {
        AppTopSnackbar.showTopSnackBar(context, "Please enter a valid email");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
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
                        Text(
                          "Create Your Account",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        AppInput(
                          hasError: isNameError,
                          controller: nameController,
                          hintText: isNameError
                              ? "Please enter your name"
                              : "Full name",
                          prefixIcon: Icons.email_outlined,
                          suffixIcon: Icons.cancel_sharp,
                          onTapIcon: () {
                            setState(() {
                              nameController.clear();
                            });
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        AppInput(
                          hasError: isEmailError,
                          controller: emailController,
                          hintText: isEmailError
                              ? "Please enter your email address"
                              : "Email address",
                          prefixIcon: Icons.email_outlined,
                          suffixIcon: Icons.cancel_sharp,
                          onTapIcon: () {
                            setState(() {
                              emailController.clear();
                            });
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        AppInput(
                          hasError: isPassError,
                          controller: passwordController,
                          obscureText: obscureText1,
                          hintText: isPassError
                              ? "Please enter your password"
                              : "Password",
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: !obscureText1
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onTapIcon: () {
                            setState(() {
                              obscureText1 = !obscureText1;
                            });
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        AppInput(
                          hasError: isComPassError,
                          controller: conformPasswordController,
                          obscureText: obscureText2,
                          hintText: isComPassError
                              ? "Please confirm your password"
                              : "Confirm Password",
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: !obscureText2
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onTapIcon: () {
                            setState(() {
                              obscureText2 = !obscureText2;
                            });
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              side: BorderSide(
                                color: AppColors.primaryColor,
                                width: 2,
                              ),
                              activeColor: AppColors.primaryColor,
                              value: isAgree,
                              onChanged: (value) {
                                setState(() {
                                  isAgree = value ?? false;
                                });
                              },
                            ),
                            Text(
                              "Agree with t & c",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: AppColors.textColor,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        AppButtons(
                          isPrimary: true,
                          text: "Create",
                          width: double.infinity,
                          height: 50,
                          icon: Icons.done_all_outlined,
                          onTap: () {
                            create();
                          },
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: AppColors.textColor,
                                  ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                context.pop('/login');
                              },
                              child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
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
              ),
            );
          },
        ),
      )),
    );
  }
}
