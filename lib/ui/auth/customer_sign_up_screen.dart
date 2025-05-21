import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/core/FirebaseServices/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';
import '../../core/utils/validation.dart';
import '../../core/widgets/custom_text_form_field.dart';
import '../../main.dart';
import 'login_screen.dart';

class CustomerSignUpScreen extends StatefulWidget {
  @override
  State<CustomerSignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<CustomerSignUpScreen> {
   final TextEditingController nameController = TextEditingController();
   final TextEditingController emailController = TextEditingController();
   final TextEditingController phoneController = TextEditingController();
   final TextEditingController passwordController = TextEditingController();
   final TextEditingController rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                vertical: size.height * 0.03,
              ),
              child: Form(
                  key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.appLogo, height: size.height * 0.07),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      width: size.width * 0.9,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                        vertical: size.height * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Create Account",
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          CustomTextFormField(
                            controller: nameController,
                            validator: Validations.ValidateFullName,
                            hintTextColor: AppColors.grey,
                            hintText: "Enter your full name",
                            iconColor: AppColors.black,
                            filledColor: Colors.white,
                          ),
                          SizedBox(height: size.height * 0.015),
                          CustomTextFormField(
                            controller: emailController,
                            validator:  Validations.validateEmail,
                            hintTextColor: AppColors.grey,
                            hintText: "your@email.com",
                            iconColor: AppColors.black,
                            filledColor: Colors.white,
                          ),
                          SizedBox(height: size.height * 0.018),
                          CustomTextFormField(
                            controller: phoneController,
                            validator: Validations.ValidatePhoneNumber,
                            hintTextColor: AppColors.grey,
                            hintText: "Enter phone number",
                            iconColor: AppColors.black,
                            filledColor: Colors.white,
                          ),
                          SizedBox(height: size.height * 0.018),
                          CustomTextFormField(
                            controller: passwordController,
                            validator:  Validations.validatePassword,
                            hintTextColor: AppColors.grey,
                            hintText: "Create password",
                            filledColor: Colors.white,
                            iconColor: AppColors.black,
                            isPassword: true,
                          ),
                          SizedBox(height: size.height * 0.018),
                          CustomTextFormField(
                            controller: rePasswordController,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (text != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null; // valid
                            },
                            hintTextColor: AppColors.grey,
                            hintText: "Confirm password",
                            filledColor: Colors.white,
                            iconColor: AppColors.black,
                            isPassword: true,
                          ),
                          SizedBox(height: size.height * 0.07),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final success = await FirebaseFunctions.createAccount(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                  EasyLoading.dismiss();
                                  if (success) {
                                    final uid = FirebaseAuth.instance.currentUser?.uid;
                                    if (uid != null) {
                                      await FirebaseFirestore.instance.collection('users').doc(uid).set({
                                        'uid': uid,
                                        'userType': 'customer',
                                        'name': nameController.text.trim(),
                                        'email': emailController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                        'createdAt': FieldValue.serverTimestamp(),
                                      });
                                    }

                                    navigatorKey.currentState?.pushNamed(PagesRouteName.customerHomeLayout);
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
                                "Create Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.045,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginScreen()),
                                ),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
