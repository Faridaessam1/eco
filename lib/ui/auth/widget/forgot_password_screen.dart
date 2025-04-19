import 'package:eco_eaters_app_3/core/utils/snack_bar_services.dart';
import 'package:eco_eaters_app_3/core/utils/validation.dart';
import 'package:eco_eaters_app_3/core/widgets/custom_elevated_button.dart';
import 'package:eco_eaters_app_3/core/widgets/custom_text_form_field.dart';
import 'package:eco_eaters_app_3/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
        body: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.098,
        vertical: size.height * 0.01,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.primaryColor.withOpacity(0.2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppAssets.appLogo, height: size.height * 0.07),
            SizedBox(height: size.height * 0.08),
            const Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            const Text(
              "Don't worry! It happens. Please enter your email address.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            CustomTextFormField(
              controller: emailController,
              validator: Validations.validateEmail,
              hintText: "Enter Your Email",
              iconPath: AppAssets.emailIcon,
              iconColor: AppColors.black,
              filledColor: AppColors.white,
            ),
            SizedBox(height: size.height * 0.02),
            CustomElevatedButton(
              buttonColor: AppColors.primaryColor,
              text: "Send Reset Link",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await resetPassword(emailController.text.trim());
                    SnackBarServices.showSuccessMessage(
                        "Reset link sent! Check your email.");

                    await Future.delayed(Duration(seconds: 2));

                    navigatorKey.currentState?.pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  } catch (e) {
                    SnackBarServices.showErrorMessage("Something went wrong!");
                  }
                }
              },
              width: 325,
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.green,
                ),
                GestureDetector(
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Back to login",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  static Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }
}
