import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';
import '../privacy&terms/privacy_policy.dart';
import '../privacy&terms/terms_of_services.dart';

class OnBoardingPage4 extends StatelessWidget {
  const OnBoardingPage4({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(

        padding: EdgeInsets.all(size.width * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context,PagesRouteName.userType, (route) => false,);
                },
                child: Text(
                  "Skip",
                  style: TextStyle(color: AppColors.black, fontSize: size.width * 0.03),
                ),
              ),
            ),
            Image.asset(AppAssets.onBoarding4, height: size.height * 0.30),
            SizedBox(height: size.height * 0.04),
            Text(
              "Join EcoEaters Today",
              style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.bold),
            ),
            Text(
              "Be part of the solution. Save money while helping reduce food waste in your community!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: size.width * 0.04, color: AppColors.black),
            ),
            SizedBox(height: size.height * 0.1),



            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: size.width * 0.035, color: Colors.black),
                    children: [
                      TextSpan(text: "By continuing, you agree to our "),
                      TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TermsOfServiceScreen()),
                            );
                          },

                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
    );
  }


  }
