import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../auth/user_type.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserTypeScreen()),
        );
      },
    );
  }
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double logoHeight = size.height * 0.3;
    final double logoWidth = size.width * 0.6;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            AppAssets.appLogo,
            height: logoHeight,
            width: logoWidth,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}