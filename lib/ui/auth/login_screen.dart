
import 'package:eco_eaters_app_3/ui/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';
import '../../core/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
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
                vertical: size.height * 0.02,
              ),
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
                          hintTextColor: AppColors.grey,
                          hintText: "Enter your email",
                          iconPath: AppAssets.emailIcon,
                          iconColor: AppColors.black,
                          filledColor: Colors.white,
                        ),
                        SizedBox(height: size.height * 0.015),


                        CustomTextFormField(
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
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),


                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,PagesRouteName.customerHomeLayout);
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
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpScreen()),
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
                      _socialButton(AppAssets.googleIcon),
                      SizedBox(width: size.width * 0.04),
                      _socialButton(AppAssets.appleIcon),
                      SizedBox(width: size.width * 0.04),
                      _socialButton(AppAssets.fbIcon),
                    ],
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }


  Widget _socialButton(String assetPath) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(assetPath, height: 25),
    );
  }
}