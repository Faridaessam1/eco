import 'package:eco_eaters_app_3/core/FirebaseServices/firebase_auth.dart';
import 'package:eco_eaters_app_3/ui/auth/phone_login.dart';
import 'package:eco_eaters_app_3/ui/auth/user_type.dart';
import 'package:eco_eaters_app_3/ui/auth/widget/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';
import '../../core/widgets/custom_text_form_field.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.primaryColor.withOpacity(0.2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.02,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Image.asset(AppAssets.appLogo, height: size.height * 0.07),
                    SizedBox(height: size.height * 0.1),

                    Container(
                      width: size.width * 0.9,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                        vertical: size.height * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            "Sign in to continue your eco-friendly journey",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                              color: AppColors.black.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),


                          CustomTextFormField(
                            controller: emailController,
                            validator: (text) {
                              if (text == null || text
                                  .trim()
                                  .isEmpty) {
                                return 'Please enter your email';
                              }
                              final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(text);
                              if (!emailValid) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            hintTextColor: AppColors.grey,
                            hintText: "Enter your email",
                            iconPath: AppAssets.emailIcon,
                            iconColor: AppColors.black,
                            filledColor: Colors.white,
                          ),
                          SizedBox(height: size.height * 0.015),


                          CustomTextFormField(
                            controller: passwordController,
                            validator: (text) {
                              if (text == null || text
                                  .trim()
                                  .isEmpty) {
                                return 'Please enter your password';
                              }
                              if (text
                                  .trim()
                                  .length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            hintTextColor: AppColors.grey,
                            hintText: "Enter your password",
                            iconPath: AppAssets.passIcon,
                            filledColor: Colors.white,
                            iconColor: AppColors.black,
                            isPassword: true,
                          ),

                          SizedBox(height: size.height * 0.01),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: GestureDetector(
                                onTap: () {
                                  navigatorKey.currentState?.push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen()),
                                  );
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: size.width * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),


                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  EasyLoading.show(status: 'Logging in...');

                                  final success = await FirebaseFunctions.login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );

                                  if (success) {
                                    final uid = FirebaseAuth.instance
                                        .currentUser?.uid;

                                    if (uid != null) {
                                      final userType = await FirebaseFunctions
                                          .getUserType(uid);
                                      EasyLoading.dismiss();

                                      if (userType == 'customer') {
                                        navigatorKey.currentState?.pushNamed(
                                            PagesRouteName.customerHomeLayout);
                                      } else if (userType == 'seller') {
                                        navigatorKey.currentState?.pushNamed(
                                            PagesRouteName.sellerHomeLayout);
                                      } else {
                                        EasyLoading.showError(
                                            'Unknown user type');
                                      }
                                    } else {
                                      EasyLoading.dismiss();
                                      EasyLoading.showError(
                                          'User ID not found');
                                    }
                                  } else {
                                    EasyLoading.dismiss();
                                    EasyLoading.showError(
                                        'Login failed. Please check your credentials.');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.015),
                              ),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.045,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserTypeScreen()),
                              ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),
                    Text(
                      "Or continue with",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialButton(AppAssets.googleIcon, () async {
                              try {
                                UserCredential userCredential = await FirebaseFunctions.signInWithGoogle();
                                print("Signed in as: ${userCredential.user?.displayName}");
                              } catch (e) {
                                print("Google sign-in failed: $e");
                              }
                            }),
                            SizedBox(width: size.width * 0.04),

                            // Phone login button
                            _socialButton(AppAssets.phoneIcon, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PhoneLoginScreen()),
                              );
                            }),
                            SizedBox(width: size.width * 0.04),
                          ],

                        ),
                      ],
                    ),
              ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _socialButton(String assetPath, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.black),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      child: Image.asset(assetPath, height: 24),
    );
  }
}