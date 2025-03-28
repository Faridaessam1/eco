
import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';

class OnBoardingPage2 extends StatelessWidget {
  const OnBoardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Align(
            alignment: Alignment.center,
            child: Text(
              "How It Works",
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            "Three simple steps to reduce food waste and save money",
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          _buildFeatureItem(Icons.store, "Restaurants List Surplus",
              "Local restaurants offer extra food at discounted prices", size),
          _buildFeatureItem(Icons.search, "Browse & Order",
              "Find delicious meals available near you", size),
          _buildFeatureItem(Icons.delivery_dining_outlined, "Pickup or Delivery",
              "Get your food delivered or pick it up yourself", size),
          SizedBox(height: size.height * 0.05),
          Center(
            child: Image.asset(
              AppAssets.onBoarding2,
              height: size.height * 0.25,
              width: size.width * 0.7,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle, Size size) {
    return ListTile(
      leading: Icon(icon, color: AppColors.green, size: size.width * 0.07),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.darkGreen,
          fontSize: size.width * 0.045,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: size.width * 0.04),
      ),
    );
  }
}