import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';

class OnBoardingPage1 extends StatelessWidget {
  const OnBoardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context,PagesRouteName.userType, (route) => false,);
                },
                child: Text(
                  "Skip",
                  style: TextStyle(color: Colors.black, fontSize: size.width * 0.01),
                ),
              ),
            ),
            Image.asset(
              AppAssets.onBoardingLogo,
              width: size.width * 0.3,
            ),
            Image.asset(
              AppAssets.onBoardingImg,
              width: size.width * 0.7,
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              "Welcome to EcoEaters",
              style: TextStyle(
                fontSize: size.width * 0.065,
                fontWeight: FontWeight.w900,
                color: AppColors.darkGreen,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Save food, save money\nSave the planet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: AppColors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Wrap(
              spacing: size.width * 0.08,
              runSpacing: size.height * 0.02,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureChip(
                    Icons.percent, "Up to 70% Off", AppColors.primaryColor, AppColors.green, size),
                _buildFeatureChip(
                    Icons.eco, "Eco-friendly", AppColors.yellow, AppColors.orange, size),
                _buildFeatureChip(
                    Icons.restaurant, "Quality Food", AppColors.primaryColor, AppColors.green, size),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String text, Color bgColor, Color textColor, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size.width * 0.045, color: AppColors.black),
          SizedBox(width: size.width * 0.02),
          Text(
            text,
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
