import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/page_route_names.dart';

class OnBoardingPage3 extends StatelessWidget {
  const OnBoardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.06),
        child: Column(
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
                    style: TextStyle(color: AppColors.black, fontSize: size.width * 0.03),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                AppAssets.onBoarding3,
                height: size.height * 0.3,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Center(
              child: Text(
                "Amazing Benefits Await",
                style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Center(
              child: Text(
                "Join our community of conscious \nconsumers and enjoy these perks",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.045, color: AppColors.black),
              ),
            ), SizedBox(height: size.height * 0.01),
            _buildFeatureItem(Icons.local_offer, "Save up to 50%",
                "Quality meals at amazing prices", size),
            _buildFeatureItem(
                Icons.eco, "Reduce Food Waste", "Help save the environment", size),
            _buildFeatureItem(
                Icons.store, "Support Local", "Help local restaurants thrive", size),

          ],
        ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(size.width * 0.02),
            child: Icon(icon, color: AppColors.lightMint, size: size.width * 0.07),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: size.width * 0.03, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

